import {
  APP_FULL_NAME,
  APP_NAME,
  TIKTOK_URL,
  WHATSAPP_NUMBER,
  WHATSAPP_URL,
} from "@/lib/constants";
import { MessageCircle } from "lucide-react";
import { SiTiktok } from "react-icons/si";

export function Footer() {
  const year = new Date().getFullYear();
  const hostname =
    typeof window !== "undefined" ? window.location.hostname : "";
  const attributionUrl = `https://caffeine.ai?utm_source=caffeine-footer&utm_medium=referral&utm_content=${encodeURIComponent(hostname)}`;

  return (
    <footer data-ocid="footer" className="border-t border-border bg-card">
      <div className="mx-auto flex w-full max-w-7xl flex-col gap-6 px-4 py-10 sm:px-6 lg:px-8">
        <div className="flex flex-col gap-6 md:flex-row md:items-start md:justify-between">
          <div className="flex flex-col gap-2">
            <span className="font-display text-lg font-bold text-gradient">
              {APP_NAME}
            </span>
            <span className="text-sm text-muted-foreground">
              {APP_FULL_NAME} · Divisi Flash Peak
            </span>
          </div>

          <div className="flex flex-col gap-3">
            <span className="text-xs font-semibold uppercase tracking-widest text-muted-foreground">
              Kontak
            </span>
            <a
              href={WHATSAPP_URL}
              target="_blank"
              rel="noreferrer"
              data-ocid="footer.whatsapp_link"
              className="flex items-center gap-2 text-sm text-foreground transition-smooth hover:text-primary"
            >
              <MessageCircle
                className="size-4 text-primary"
                aria-hidden="true"
              />
              Admin WhatsApp {WHATSAPP_NUMBER}
            </a>
            <a
              href={TIKTOK_URL}
              target="_blank"
              rel="noreferrer"
              data-ocid="footer.tiktok_link"
              className="flex items-center gap-2 text-sm text-foreground transition-smooth hover:text-primary"
            >
              <SiTiktok className="size-4 text-primary" aria-hidden="true" />
              TikTok WNU CLUB
            </a>
          </div>
        </div>

        <div className="flex flex-col gap-2 border-t border-border pt-6 text-xs text-muted-foreground md:flex-row md:items-center md:justify-between">
          <p>
            © {year} {APP_FULL_NAME} ({APP_NAME}). All Rights Reserved.
          </p>
          <p>
            Built with love using{" "}
            <a
              href={attributionUrl}
              target="_blank"
              rel="noreferrer"
              className="font-medium text-primary underline-offset-4 transition-smooth hover:underline"
            >
              caffeine.ai
            </a>
          </p>
        </div>
      </div>
    </footer>
  );
}
