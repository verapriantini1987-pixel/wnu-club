import { render, screen, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it } from "vitest";

import App from "@/App";
import {
  APP_FULL_NAME,
  APP_NAME,
  APP_TAGLINE,
  ROSTER,
  TIKTOK_URL,
  WHATSAPP_URL,
} from "@/lib/constants";

describe("WNU CLUB landing page", () => {
  it("renders the hero title, tagline, and primary calls to action", () => {
    render(<App />);

    const hero = screen.getByTestId("landing.hero_section");
    expect(within(hero).getByRole("heading", { level: 1 })).toHaveTextContent(
      APP_FULL_NAME,
    );
    expect(within(hero).getByRole("heading", { level: 1 })).toHaveTextContent(
      APP_NAME,
    );
    expect(within(hero).getByText(APP_TAGLINE)).toBeInTheDocument();

    expect(screen.getByTestId("landing.primary_button")).toHaveAttribute(
      "href",
      WHATSAPP_URL,
    );
    expect(screen.getByTestId("landing.secondary_button")).toHaveAttribute(
      "href",
      TIKTOK_URL,
    );
  });

  it("renders all nine roster cards with names, nicknames, and UIDs", () => {
    render(<App />);

    const roster = screen.getByTestId("landing.roster_section");
    ROSTER.forEach((member, index) => {
      const card = within(roster).getByTestId(
        `landing.roster_card.${index + 1}`,
      );
      expect(within(card).getByText(member.name)).toBeInTheDocument();
      expect(within(card).getByText(member.nickname)).toBeInTheDocument();
      expect(
        within(card).getByAltText(`Foto placeholder ${member.nickname}`),
      ).toBeInTheDocument();
    });
  });

  it("marks only ILHAMSYAH as Captain", () => {
    render(<App />);

    const roster = screen.getByTestId("landing.roster_section");
    const captainCard = within(roster).getByTestId("landing.roster_card.1");
    expect(within(captainCard).getAllByText("Captain").length).toBeGreaterThan(
      0,
    );
    expect(within(captainCard).getByText("ILHAMSYAH")).toBeInTheDocument();

    const otherCard = within(roster).getByTestId("landing.roster_card.2");
    expect(within(otherCard).queryByText("Captain")).not.toBeInTheDocument();
  });

  it("opens the TikTok profile from the community section", () => {
    render(<App />);

    expect(screen.getByTestId("landing.tiktok_button")).toHaveAttribute(
      "href",
      TIKTOK_URL,
    );
  });

  it("opens the WhatsApp registration draft from Join Us", () => {
    render(<App />);

    const joinButton = screen.getByTestId("landing.join_button");
    expect(joinButton).toHaveAttribute("href", WHATSAPP_URL);
    expect(joinButton).toHaveTextContent("Hubungi Admin via WhatsApp");
  });

  it("shows the admin contact and 2026 copyright in the footer", () => {
    render(<App />);

    const footer = screen.getByTestId("footer");
    expect(footer).toHaveTextContent("Admin WhatsApp +62 831-8346-8485");
    expect(footer).toHaveTextContent(
      `© ${new Date().getFullYear()} ${APP_FULL_NAME} (${APP_NAME}). All Rights Reserved.`,
    );
  });

  it("navigates to each section from the desktop navbar", () => {
    render(<App />);

    const nav = screen.getByRole("navigation", { name: "Primary" });
    expect(within(nav).getByRole("link", { name: "Home" })).toHaveAttribute(
      "href",
      "#home",
    );
    expect(within(nav).getByRole("link", { name: "Roster" })).toHaveAttribute(
      "href",
      "#roster",
    );
    expect(within(nav).getByRole("link", { name: "TikTok" })).toHaveAttribute(
      "href",
      "#tiktok",
    );
    expect(within(nav).getByRole("link", { name: "Join Us" })).toHaveAttribute(
      "href",
      "#join",
    );
    expect(within(nav).getByRole("link", { name: "Contact" })).toHaveAttribute(
      "href",
      "#contact",
    );
  });

  it("opens and closes the mobile navigation menu", async () => {
    const user = userEvent.setup();
    render(<App />);

    expect(
      screen.queryByRole("navigation", { name: "Mobile" }),
    ).not.toBeInTheDocument();

    await user.click(screen.getByTestId("nav.open_modal_button"));
    const mobileNav = await screen.findByRole("navigation", {
      name: "Mobile",
    });
    expect(
      within(mobileNav).getByRole("link", { name: "Roster" }),
    ).toBeInTheDocument();

    await user.click(within(mobileNav).getByRole("link", { name: "Roster" }));
    expect(
      screen.queryByRole("navigation", { name: "Mobile" }),
    ).not.toBeInTheDocument();
  });
});
