import { Button } from "@/components/ui/button";
import {
  APP_FULL_NAME,
  APP_NAME,
  APP_TAGLINE,
  JOIN_STEPS,
  ROSTER,
  TEAM_STATS,
  TIKTOK_URL,
  WHATSAPP_URL,
  formatUid,
} from "@/lib/constants";
import { cn } from "@/lib/utils";
import { Crown, MessageCircle, Trophy } from "lucide-react";
import { SiTiktok } from "react-icons/si";

function SectionHeading({
  eyebrow,
  title,
  description,
}: {
  eyebrow: string;
  title: string;
  description?: string;
}) {
  return (
    <div className="flex flex-col gap-3">
      <span className="text-xs font-semibold uppercase tracking-widest text-gradient">
        {eyebrow}
      </span>
      <h2 className="font-display text-3xl font-bold tracking-tight text-foreground md:text-4xl">
        {title}
      </h2>
      {description ? (
        <p className="max-w-2xl text-muted-foreground">{description}</p>
      ) : null}
    </div>
  );
}

export function LandingPage() {
  return (
    <div className="flex flex-col">
      {/* HERO */}
      <section
        id="home"
        data-ocid="landing.hero_section"
        className="relative overflow-hidden border-b border-border bg-arena"
      >
        <div className="pointer-events-none absolute inset-0 hex-grid opacity-60" />
        <div className="relative mx-auto flex w-full max-w-7xl flex-col items-start gap-7 px-4 py-20 sm:px-6 md:py-28 lg:px-8">
          <span className="flex items-center gap-2 rounded-full border border-gold bg-primary/10 px-4 py-1.5 text-xs font-semibold uppercase tracking-widest text-primary">
            <Trophy className="size-3.5" aria-hidden="true" />
            eSport Flash Peak · Indonesia
          </span>
          <h1 className="max-w-4xl font-display text-4xl font-bold leading-tight tracking-tight text-foreground md:text-6xl lg:text-7xl">
            {APP_FULL_NAME}{" "}
            <span className="text-gradient text-glow-gold">({APP_NAME})</span>
          </h1>
          <p className="max-w-2xl text-lg text-muted-foreground md:text-xl">
            {APP_TAGLINE}
          </p>
          <div className="flex flex-wrap items-center gap-3">
            <Button
              asChild
              size="lg"
              className="rounded-full bg-gradient-primary shadow-gold"
            >
              <a
                href={WHATSAPP_URL}
                target="_blank"
                rel="noreferrer"
                data-ocid="landing.primary_button"
              >
                <MessageCircle className="size-4" aria-hidden="true" />
                Bergabung via WhatsApp
              </a>
            </Button>
            <Button
              asChild
              size="lg"
              variant="outline"
              className="rounded-full border-gold"
            >
              <a
                href={TIKTOK_URL}
                target="_blank"
                rel="noreferrer"
                data-ocid="landing.secondary_button"
              >
                <SiTiktok className="size-4" aria-hidden="true" />
                Kunjungi TikTok Kami
              </a>
            </Button>
          </div>

          <div className="mt-6 grid w-full grid-cols-2 gap-3 sm:grid-cols-3">
            {TEAM_STATS.map((stat) => (
              <div
                key={stat.label}
                className="flex flex-col gap-1 rounded-xl border border-border bg-card/70 px-4 py-3 backdrop-blur"
              >
                <span className="font-display text-2xl font-bold text-primary">
                  {stat.value}
                </span>
                <span className="text-xs text-muted-foreground">
                  {stat.label}
                </span>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ROSTER */}
      <section
        id="roster"
        data-ocid="landing.roster_section"
        className="mx-auto flex w-full max-w-7xl flex-col gap-8 px-4 py-20 sm:px-6 lg:px-8"
      >
        <SectionHeading
          eyebrow="Roster"
          title="Sembilan pejuang, satu keluarga"
          description="Roster inti WNU CLUB yang siap mendominasi puncak di setiap turnamen Flash Peak."
        />
        <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {ROSTER.map((member, index) => {
            const isCaptain = member.role === "Captain";
            return (
              <article
                key={member.nickname}
                data-ocid={`landing.roster_card.${index + 1}`}
                className={cn(
                  "group relative flex flex-col gap-4 overflow-hidden rounded-xl border bg-card p-6 shadow-subtle transition-smooth",
                  "hover:-translate-y-1 hover:shadow-gold",
                  isCaptain
                    ? "border-gold ring-1 ring-gold/60"
                    : "border-cyan/40 hover:border-gold",
                )}
              >
                <span
                  aria-hidden="true"
                  className="absolute inset-x-0 top-0 h-1 bg-gradient-primary"
                />
                {isCaptain ? (
                  <span className="absolute right-4 top-4 flex items-center gap-1.5 rounded-full border border-gold bg-primary/15 px-3 py-1 text-xs font-semibold uppercase tracking-wider text-primary">
                    <Crown className="size-3.5" aria-hidden="true" />
                    Captain
                  </span>
                ) : null}
                <div className="size-16 overflow-hidden rounded-lg border border-gold/50 bg-gradient-subtle">
                  <img
                    src="/assets/images/placeholder.svg"
                    alt={`Foto placeholder ${member.nickname}`}
                    className="size-full object-cover"
                    loading="lazy"
                  />
                </div>
                <div className="flex flex-col gap-1">
                  <h3 className="font-display text-lg font-semibold text-foreground">
                    {member.name}
                  </h3>
                  <span className="font-mono text-sm text-primary">
                    {member.nickname}
                  </span>
                </div>
                <dl className="flex flex-col gap-2 border-t border-border pt-3 text-sm">
                  <div className="flex items-center justify-between gap-3">
                    <dt className="text-muted-foreground">UID</dt>
                    <dd
                      className={cn(
                        "font-mono",
                        member.uid === "-"
                          ? "text-muted-foreground"
                          : "text-cyan",
                      )}
                    >
                      {formatUid(member.uid)}
                    </dd>
                  </div>
                  <div className="flex items-center justify-between gap-3">
                    <dt className="text-muted-foreground">Role</dt>
                    <dd
                      className={cn(
                        "rounded-full border px-3 py-0.5 text-xs font-medium",
                        isCaptain
                          ? "border-gold bg-primary/15 text-primary"
                          : "border-cyan/40 bg-cyan/10 text-cyan",
                      )}
                    >
                      {member.role}
                    </dd>
                  </div>
                </dl>
              </article>
            );
          })}
        </div>
      </section>

      {/* TIKTOK */}
      <section
        id="tiktok"
        data-ocid="landing.tiktok_section"
        className="border-y border-border bg-card"
      >
        <div className="mx-auto flex w-full max-w-7xl flex-col items-center gap-6 px-4 py-20 text-center sm:px-6 lg:px-8">
          <span className="flex size-14 items-center justify-center rounded-2xl bg-gradient-primary shadow-gold">
            <SiTiktok
              className="size-7 text-primary-foreground"
              aria-hidden="true"
            />
          </span>
          <SectionHeading
            eyebrow="TikTok"
            title="Ikuti keseruan WNU CLUB"
            description="Highlight pertandingan, momen kocak, dan keseharian tim ada di TikTok resmi kami."
          />
          <Button
            asChild
            size="lg"
            className="rounded-full bg-gradient-primary shadow-gold"
          >
            <a
              href={TIKTOK_URL}
              target="_blank"
              rel="noreferrer"
              data-ocid="landing.tiktok_button"
            >
              <SiTiktok className="size-4" aria-hidden="true" />
              Buka TikTok WNU CLUB
            </a>
          </Button>
        </div>
      </section>

      {/* JOIN US */}
      <section
        id="join"
        data-ocid="landing.join_section"
        className="mx-auto flex w-full max-w-7xl flex-col gap-8 px-4 py-20 sm:px-6 lg:px-8"
      >
        <SectionHeading
          eyebrow="Join Us"
          title="Bergabung dengan WNU CLUB"
          description="Empat langkah simpel untuk jadi bagian dari keluarga Warung Nenek Uka."
        />
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-4">
          {JOIN_STEPS.map((step, index) => (
            <div
              key={step.title}
              data-ocid={`landing.join_step.${index + 1}`}
              className="flex flex-col gap-3 rounded-xl border border-border bg-card p-6 shadow-subtle"
            >
              <span className="flex size-9 items-center justify-center rounded-full bg-gradient-primary font-display text-sm font-bold text-primary-foreground">
                {index + 1}
              </span>
              <h3 className="font-display text-lg font-semibold text-foreground">
                {step.title}
              </h3>
              <p className="text-sm text-muted-foreground">{step.body}</p>
            </div>
          ))}
        </div>
        <div className="flex flex-col items-start gap-4 rounded-2xl border border-gold bg-gradient-subtle px-6 py-8 md:flex-row md:items-center md:justify-between">
          <div className="flex flex-col gap-1">
            <h3 className="font-display text-xl font-bold text-foreground">
              Siap tampil di panggung?
            </h3>
            <p className="text-sm text-muted-foreground">
              Chat admin sekarang dan mulai perjalananmu di Flash Peak.
            </p>
          </div>
          <Button
            asChild
            size="lg"
            className="rounded-full bg-gradient-primary shadow-gold"
          >
            <a
              href={WHATSAPP_URL}
              target="_blank"
              rel="noreferrer"
              data-ocid="landing.join_button"
            >
              <MessageCircle className="size-4" aria-hidden="true" />
              Hubungi Admin via WhatsApp
            </a>
          </Button>
        </div>
      </section>

      {/* CONTACT */}
      <section
        id="contact"
        data-ocid="landing.contact_section"
        className="border-t border-border bg-card"
      >
        <div className="mx-auto flex w-full max-w-7xl flex-col gap-8 px-4 py-20 sm:px-6 lg:px-8">
          <SectionHeading
            eyebrow="Contact"
            title="Hubungi WNU CLUB"
            description="Punya pertanyaan soal tim, sponsor, atau kolaborasi? Kami siap."
          />
          <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
            <a
              href={WHATSAPP_URL}
              target="_blank"
              rel="noreferrer"
              data-ocid="landing.contact_whatsapp_link"
              className={cn(
                "flex items-center gap-4 rounded-xl border border-border bg-background p-6",
                "transition-smooth hover:border-gold hover:shadow-gold",
              )}
            >
              <span className="flex size-12 items-center justify-center rounded-xl bg-gradient-primary">
                <MessageCircle
                  className="size-6 text-primary-foreground"
                  aria-hidden="true"
                />
              </span>
              <div className="flex flex-col">
                <span className="font-display text-base font-semibold text-foreground">
                  Admin WhatsApp
                </span>
                <span className="text-sm text-muted-foreground">
                  +62 831-8346-8485
                </span>
              </div>
            </a>
            <a
              href={TIKTOK_URL}
              target="_blank"
              rel="noreferrer"
              data-ocid="landing.contact_tiktok_link"
              className={cn(
                "flex items-center gap-4 rounded-xl border border-border bg-background p-6",
                "transition-smooth hover:border-gold hover:shadow-gold",
              )}
            >
              <span className="flex size-12 items-center justify-center rounded-xl bg-gradient-primary">
                <SiTiktok
                  className="size-6 text-primary-foreground"
                  aria-hidden="true"
                />
              </span>
              <div className="flex flex-col">
                <span className="font-display text-base font-semibold text-foreground">
                  TikTok Resmi
                </span>
                <span className="text-sm text-muted-foreground">WNU CLUB</span>
              </div>
            </a>
          </div>
        </div>
      </section>
    </div>
  );
}
