import { apiInitializer } from "discourse/lib/api";
import CustomHeaderLinks from "../components/custom-header-links";

export default apiInitializer("1.29.0", (api) => {
  if (!settings.header_links) {
    return;
  }

  // On actual iPhones (especially in Safari), the first tap often triggers the :hover state,
  // as it’s used to simulate a mouse hover action. A second tap is required to activate a click event.
  // This can result in :hover styles being triggered even on touch.
  // However, it is hard to remove that pseudo class programmatically.

  // instead, we use the .expanded class and in the mobile CSS we use a media query
  // to distinguish between devices that can actually hover and devices that cannot.
  // Note that this requires an actual touch device, the Firefox touch emulation works differently!!

  document.addEventListener('click', function(event) {
    const toggle = event.target.closest('.custom-header-link-title');
    const dropdown = toggle ? toggle.closest('.custom-header-link') : null;

    // If a toggle button was clicked, handle the dropdown state
    if (dropdown) {
      dropdown.classList.toggle('expanded');

      // Close other open dropdowns
      document.querySelectorAll('.custom-header-link').forEach(function(otherDropdown) {
        if (otherDropdown !== dropdown) {
          otherDropdown.classList.remove('expanded');
        }
      });
    } else {
      // If clicked outside any dropdown, close all dropdowns
      document.querySelectorAll('.custom-header-link').forEach(function(dropdown) {
        dropdown.classList.remove('expanded');
      });
    }
  });

  switch(settings.links_position) {
    case "left":
      api.renderAfterWrapperOutlet("home-logo", CustomHeaderLinks);
      break;
    case "right":
      api.headerButtons.add("dropdown-header", CustomHeaderLinks, {
        before: "auth",
      });
      break;
    case "below":
      api.renderInOutlet("after-header", CustomHeaderLinks);
      break;
  }
});
