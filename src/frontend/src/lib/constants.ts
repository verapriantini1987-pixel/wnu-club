export const APP_NAME = "WNU CLUB";
export const APP_FULL_NAME = "WARUNG NENEK UKA";
export const APP_TAGLINE = "Dominate the Peak, Powered by Family.";

export const WHATSAPP_NUMBER = "+62 831-8346-8485";
export const WHATSAPP_DRAFT =
  "Halo Admin WNU CLUB, saya ingin mendaftar ke tim eSport Flash Peak.";
export const WHATSAPP_URL = `https://wa.me/6283183468485?text=${encodeURIComponent(
  WHATSAPP_DRAFT,
)}`;
export const TIKTOK_HANDLE = "WNU CLUB";
export const TIKTOK_URL = "https://www.tiktok.com/@wnuclub";

export interface NavLink {
  label: string;
  href: string;
}

export const NAV_LINKS: NavLink[] = [
  { label: "Home", href: "#home" },
  { label: "Roster", href: "#roster" },
  { label: "TikTok", href: "#tiktok" },
  { label: "Join Us", href: "#join" },
  { label: "Contact", href: "#contact" },
];

export interface RosterMember {
  name: string;
  nickname: string;
  uid: string;
  role: string;
}

export const ROSTER: RosterMember[] = [
  {
    name: "ILHAMSYAH",
    nickname: "WNU.Icaaaaa",
    uid: "11561868",
    role: "Captain",
  },
  {
    name: "Aditya Rizki Destiansyah",
    nickname: "WNU.Mikk",
    uid: "12299750",
    role: "Member",
  },
  {
    name: "Abdullah Hilmi",
    nickname: "WNU.Ω",
    uid: "12759754",
    role: "Member",
  },
  {
    name: "Yudistira",
    nickname: "WNU.CELIAA",
    uid: "11829747",
    role: "Member",
  },
  {
    name: "Rachmat Dava Rangga Wijaya",
    nickname: "WNU.ZEUSs⚜️",
    uid: "11997056",
    role: "Member",
  },
  {
    name: "Muhammad Keysha Alvaro",
    nickname: "WNU.Syakiraa",
    uid: "11919263",
    role: "Member",
  },
  {
    name: "Kawian Adi Pramana",
    nickname: "WNU.Wyanz",
    uid: "11700724",
    role: "Member",
  },
  {
    name: "Diki Ilham Setiawan",
    nickname: "WNU.Gilang",
    uid: "-",
    role: "Member",
  },
  {
    name: "ANGGA",
    nickname: "WNU.Cacaa",
    uid: "11561906",
    role: "Member",
  },
];

export const UID_UNAVAILABLE = "Belum tersedia";

export function formatUid(uid: string): string {
  return uid === "-" ? UID_UNAVAILABLE : uid;
}

export interface TeamStat {
  label: string;
  value: string;
}

export const TEAM_STATS: TeamStat[] = [
  { label: "Win Rate", value: "78%" },
  { label: "Turnamen", value: "24" },
  { label: "Season", value: "2026" },
];

export interface JoinStep {
  title: string;
  body: string;
}

export const JOIN_STEPS: JoinStep[] = [
  {
    title: "Hubungi Admin",
    body: "Chat admin WNU CLUB lewat WhatsApp dan sampaikan minatmu bergabung.",
  },
  {
    title: "Kirim Rekaman",
    body: "Kirim klip permainanmu di Flash Peak untuk kami review.",
  },
  {
    title: "Seleksi Tim",
    body: "Ikuti sesi tryout dan tunjukkan kemampuanmu di arena.",
  },
  {
    title: "Resmi Bergabung",
    body: "Kalau lolos, kamu masuk roster dan langsung bertanding.",
  },
];
