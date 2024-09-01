import { apiInitializer } from "discourse/lib/api";
import CustomHeaderLinks from "../components/custom-header-links";

export default apiInitializer("1.29.0", (api) => {
  if (!settings.header_links) {
    return;
  }

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
