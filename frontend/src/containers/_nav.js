import React from "react";
import CIcon from "@coreui/icons-react";

const _nav = [
  {
    _tag: "CSidebarNavItem",
    name: "Dashboard",
    to: "/dashboard",
    icon: <CIcon name="cil-speedometer" customClasses="c-sidebar-nav-icon" />,
    badge: {
      color: "info",
      text: "NEW",
    },
  },
  {
    _tag: "CSidebarNavDropdown",
    name: "Lands",
    route: "/lands",
    icon: "cil-puzzle",
    _children: [
      {
        _tag: "CSidebarNavItem",
        name: "All Lands",
        to: "/lands/all-lands",
      },
      {
        _tag: "CSidebarNavItem",
        name: "Add New Land",
        to: "/lands/add-new-land",
      },
    ],
  },
];

export default _nav;
