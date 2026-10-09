import { Button } from "@/components/ui/button";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";
import { APP_FULL_NAME, APP_NAME, NAV_LINKS } from "@/lib/constants";
import { cn } from "@/lib/utils";
import { Menu } from "lucide-react";
import { useState } from "react";

function NavItemLink({
  label,
  href,
  onNavigate,
}: {
  label: string;
  href: string;
  onNavigate?: () => void;
}) {
  return (
    <a
      href={href}
      onClick={onNavigate}
      className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition-smooth hover:bg-secondary hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
    >
      {label}
    </a>
  );
}

export function NavBar() {
  const [mobileOpen, setMobileOpen] = useState(false);

  return (
    <header
      data-ocid="nav.header"
      className="sticky top-0 z-40 border-b border-border bg-card/80 backdrop-blur"
    >
      <div className="mx-auto flex h-16 w-full max-w-7xl items-center justify-between gap-4 px-4 sm:px-6 lg:px-8">
        <a
          href="#home"
          data-ocid="nav.link"
          className="flex min-w-0 items-center gap-2.5"
        >
          <img
            src="/assets/images/wnu-club-logo.png"
            alt="Logo WNU CLUB"
            data-ocid="nav.logo"
            className="size-10 shrink-0 rounded-lg border border-gold object-cover shadow-gold"
          />
          <span className="flex min-w-0 flex-col leading-none">
            <span className="truncate font-display text-base font-bold tracking-tight text-gradient">
              {APP_NAME}
            </span>
            <span className="truncate text-[11px] text-muted-foreground">
              {APP_FULL_NAME}
            </span>
          </span>
        </a>

        <nav aria-label="Primary" className="hidden items-center gap-1 lg:flex">
          {NAV_LINKS.map((link) => (
            <NavItemLink key={link.href} label={link.label} href={link.href} />
          ))}
        </nav>

        <div className="flex items-center gap-2">
          <Button
            asChild
            size="sm"
            className="hidden rounded-full bg-gradient-primary shadow-gold sm:inline-flex"
          >
            <a href="#join" data-ocid="nav.join_button">
              Join Us
            </a>
          </Button>

          <Sheet open={mobileOpen} onOpenChange={setMobileOpen}>
            <SheetTrigger asChild>
              <Button
                type="button"
                variant="ghost"
                size="icon"
                aria-label="Buka menu navigasi"
                data-ocid="nav.open_modal_button"
                className="lg:hidden"
              >
                <Menu className="size-5" aria-hidden="true" />
              </Button>
            </SheetTrigger>
            <SheetContent side="right" className="w-72 bg-card">
              <SheetHeader>
                <SheetTitle className="font-display text-gradient">
                  {APP_NAME}
                </SheetTitle>
              </SheetHeader>
              <nav aria-label="Mobile" className="flex flex-col gap-1 px-4">
                {NAV_LINKS.map((link) => (
                  <NavItemLink
                    key={link.href}
                    label={link.label}
                    href={link.href}
                    onNavigate={() => setMobileOpen(false)}
                  />
                ))}
              </nav>
            </SheetContent>
          </Sheet>
        </div>
      </div>
    </header>
  );
}
