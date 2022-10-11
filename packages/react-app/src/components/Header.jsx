import { BackTop, PageHeader } from "antd";
import React from "react";

// displays a page header

export default function Header() {
  return (
    <a
      href="https://rostyslavdzhohola.notion.site/Tech-Resume-Rostyslav-Dzhohola-82ce6ab26c5c4d0cb1f968cc82bfe1ea" 
      target="_blank"
      rel="noopener noreferrer"
    >
      <PageHeader
        title="🏗 scaffold-eth-challange-1"
        subTitle="by Rostyslav Dzhohola"
        style={{ cursor: "pointer", color: "#ffa940" }}
      />
    </a>
  );
}
