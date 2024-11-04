import type {Metadata} from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Skoglycke Consulting AB",
  description: "Skoglycke Consulting AB",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        {children}
      </body>
    </html>
  );
}
