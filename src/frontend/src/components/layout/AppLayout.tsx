import { Footer } from "@/components/layout/Footer";
import { NavBar } from "@/components/layout/NavBar";
import { Toaster } from "@/components/ui/sonner";

export function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-screen flex-col bg-arena">
      <NavBar />
      <main data-ocid="page" className="flex-1">
        {children}
      </main>
      <Footer />
      <Toaster position="top-right" richColors closeButton />
    </div>
  );
}
