import { render, screen, within } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import App from "@/App";
import { APP_FULL_NAME, APP_NAME, TEAM_STATS } from "@/lib/constants";

describe("WNU CLUB branding baseline", () => {
  it("loads the default route without a blank screen", () => {
    render(<App />);

    const page = screen.getByTestId("page");
    expect(page).toBeInTheDocument();
    expect(page).not.toBeEmptyDOMElement();
    expect(
      screen.getByRole("heading", { level: 1, name: /WARUNG NENEK UKA/ }),
    ).toBeInTheDocument();
  });

  it("renders the header brand mark with the logo image and team names", () => {
    render(<App />);

    const header = screen.getByTestId("nav.header");
    const brand = within(header).getByTestId("nav.link");

    const logo = within(brand).getByAltText("Logo WNU CLUB");
    expect(logo).toHaveAttribute("src", "/assets/images/wnu-club-logo.png");
    expect(within(brand).getByText(APP_NAME)).toBeInTheDocument();
    expect(within(brand).getByText(APP_FULL_NAME)).toBeInTheDocument();
    expect(brand).toHaveAttribute("href", "#home");
  });

  it("shows the hero team stats grid without the removed Peringkat card", () => {
    render(<App />);

    const hero = screen.getByTestId("landing.hero_section");
    for (const stat of TEAM_STATS) {
      expect(within(hero).getByText(stat.label)).toBeInTheDocument();
      expect(within(hero).getByText(stat.value)).toBeInTheDocument();
    }

    expect(within(hero).queryByText("Peringkat")).not.toBeInTheDocument();
    expect(within(hero).queryByText("#1")).not.toBeInTheDocument();
  });
});
