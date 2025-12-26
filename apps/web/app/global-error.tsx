'use client'
 
export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <html>
      <body>
        <div className="flex h-screen flex-col items-center justify-center gap-4">
          <h2 className="text-2xl font-bold">500 - Server Error</h2>
          <p>Global Application Error</p>
          <button onClick={() => reset()} className="text-blue-500 underline">
            Try again
          </button>
        </div>
      </body>
    </html>
  )
}