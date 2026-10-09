import { describe, expect, it } from "vitest";

import {
  APP_FULL_NAME,
  APP_NAME,
  APP_TAGLINE,
  NAV_LINKS,
  ROSTER,
  TIKTOK_URL,
  UID_UNAVAILABLE,
  WHATSAPP_DRAFT,
  WHATSAPP_NUMBER,
  WHATSAPP_URL,
  formatUid,
} from "@/lib/constants";

describe("WNU CLUB constants", () => {
  it("exposes the team identity and tagline", () => {
    expect(APP_FULL_NAME).toBe("WARUNG NENEK UKA");
    expect(APP_NAME).toBe("WNU CLUB");
    expect(APP_TAGLINE).toBe("Dominate the Peak, Powered by Family.");
  });

  it("links WhatsApp to the admin number with the registration draft", () => {
    expect(WHATSAPP_NUMBER).toBe("+62 831-8346-8485");
    expect(WHATSAPP_URL).toContain("https://wa.me/6283183468485");
    expect(WHATSAPP_URL).toContain(encodeURIComponent(WHATSAPP_DRAFT));
    expect(WHATSAPP_DRAFT).toBe(
      "Halo Admin WNU CLUB, saya ingin mendaftar ke tim eSport Flash Peak.",
    );
  });

  it("points TikTok at the WNU CLUB profile", () => {
    expect(TIKTOK_URL).toBe("https://www.tiktok.com/@wnuclub");
  });

  it("defines the five navigation links in order", () => {
    expect(NAV_LINKS.map((link) => link.label)).toEqual([
      "Home",
      "Roster",
      "TikTok",
      "Join Us",
      "Contact",
    ]);
    expect(NAV_LINKS.map((link) => link.href)).toEqual([
      "#home",
      "#roster",
      "#tiktok",
      "#join",
      "#contact",
    ]);
  });

  it("seeds nine roster members with ILHAMSYAH as the only Captain", () => {
    expect(ROSTER).toHaveLength(9);
    const captains = ROSTER.filter((member) => member.role === "Captain");
    expect(captains).toHaveLength(1);
    expect(captains[0].name).toBe("ILHAMSYAH");
    expect(captains[0].nickname).toBe("WNU.Icaaaaa");
    expect(captains[0].uid).toBe("11561868");
  });

  it("formats an unavailable UID as a readable label", () => {
    expect(formatUid("-")).toBe(UID_UNAVAILABLE);
    expect(formatUid("11561868")).toBe("11561868");
  });
});
