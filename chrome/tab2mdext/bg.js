// chrome.notifications requires an iconUrl for "basic" toasts. A bundled file is more
// reliable than a data URL (Chrome's image downloader rejects degenerate data URLs).
const ICON = "icon.png";

function notify(title, message) {
  chrome.notifications.create({
    type: "basic",
    iconUrl: ICON,
    title,
    message,
  });
}

// Runs in the page (active tab). The page is focused and a secure context, which is exactly
// what the clipboard APIs require — the offscreen-document approach failed because offscreen
// docs can never be focused. execCommand("copy") is kept as a fallback.
async function copyToClipboard(text) {
  try {
    await navigator.clipboard.writeText(text);
    return { ok: true };
  } catch (e) {
    try {
      const ta = document.createElement("textarea");
      ta.value = text;
      ta.style.position = "fixed";
      ta.style.opacity = "0";
      document.body.appendChild(ta);
      ta.focus();
      ta.select();
      const ok = document.execCommand("copy");
      ta.remove();
      return ok ? { ok: true } : { ok: false, error: "execCommand('copy') returned false" };
    } catch (e2) {
      return { ok: false, error: String(e2?.message || e2) };
    }
  }
}

chrome.action.onClicked.addListener(async () => {
  try {
    // NOTE: currentWindow keys off the *focused* window. If you inspect this with detached
    // DevTools focused, DevTools becomes "current" and this returns [] — a debugging
    // artifact, not a real bug. Normal icon clicks return the real tabs.
    const tabs = await chrome.tabs.query({ currentWindow: true });
    if (tabs.length === 0) {
      notify("No tabs copied", "No tabs found in the current window.");
      return;
    }

    const md = tabs.map(t => `- [${t.title}](${t.url})`).join("\n");

    const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
    if (!activeTab?.id) {
      notify("Copy failed", "Could not find an active tab to copy from.");
      return;
    }

    let result;
    try {
      const injection = await chrome.scripting.executeScript({
        target: { tabId: activeTab.id },
        func: copyToClipboard,
        args: [md],
      });
      result = injection?.[0]?.result;
    } catch (injectErr) {
      // chrome://, the Web Store, and the new-tab page can't be scripted.
      notify(
        "Copy failed",
        "Can't copy from this page (e.g. chrome:// or the Web Store). Switch to a normal tab and try again.",
      );
      return;
    }

    if (result?.ok) {
      notify(
        "Tabs copied",
        `Copied ${tabs.length} tab${tabs.length === 1 ? "" : "s"} to clipboard.`,
      );
    } else {
      notify("Copy failed", result?.error || "The clipboard write did not succeed.");
    }
  } catch (err) {
    console.error("tab2mdext: copy failed", err);
    notify("Copy failed", String(err?.message || err));
  }
});
