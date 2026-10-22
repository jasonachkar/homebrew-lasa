/* Keep header controls and search shortcuts local, with no dependencies or requests. */
for (const trigger of document.querySelectorAll(".lasa-toggle")) {
  const toggle = document.getElementById(trigger.htmlFor);
  if (!toggle) continue;
  for (const type of ["keydown", "keyup"]) {
    trigger.addEventListener(type, (event) => {
      if (event.key !== "Enter" && event.key !== " ") return;
      event.preventDefault();
      // Material also delegates Enter activation; handle each key once here.
      event.stopPropagation();
      if (type === "keyup") trigger.click();
    });
  }
  if (trigger.hasAttribute("aria-expanded")) {
    const update = () => trigger.setAttribute("aria-expanded", String(toggle.checked));
    toggle.addEventListener("change", update);
    update();
  }
}

document.addEventListener("keydown", (event) => {
  if (!(event.ctrlKey || event.metaKey) || event.key.toLowerCase() !== "k" || event.altKey || event.isComposing) return;
  const toggle = document.getElementById("__search");
  const input = document.querySelector('[data-md-component="search-query"]');
  if (!toggle || !input) return;
  event.preventDefault();
  toggle.checked = true;
  toggle.dispatchEvent(new Event("change", { bubbles: true }));
  input.focus();
});
