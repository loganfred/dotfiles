chrome.action.onClicked.addListener(async () => {
  const tabs = await chrome.tabs.query({ currentWindow: true });
  const md = tabs.map(t => `- [${t.title}](${t.url})`).join("\n");
  await chrome.scripting.executeScript({
    target: { tabId: tabs.find(t => t.active).id },
    func: text => navigator.clipboard.writeText(text),
    args: [md],
  });
});
