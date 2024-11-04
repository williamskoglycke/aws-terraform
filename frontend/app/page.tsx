export const dynamic = 'force-dynamic'

export default async function Home() {
    const data = await fetch(`http://${process.env.BACKEND_API || 'backend:8080'}/hello`);
    const helloResponse = await data.text()
    return (
        <div
            className="grid grid-rows-[20px_1fr_20px] items-center justify-items-center min-h-screen p-8 pb-20 gap-16 sm:p-20 font-[family-name:var(--font-geist-sans)]">
            <main className="flex flex-col gap-8 row-start-2 items-center sm:items-start">
                <h1 className="text-4xl font-bold text-center sm:text-left">Welcome to Skoglycke Consulting AB</h1>
                <p className="text-lg text-center sm:text-left">
                    Skoglycke Consulting AB is a consulting company that specializes in
                    software development and cloud computing.
                </p>
                <p className="text-lg text-center sm:text-left">Hello {helloResponse}</p>
            </main>
        </div>
    );
}
