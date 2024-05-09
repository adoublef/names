export function redirect(location: string) {
  const headers = new Headers({ Location: location });
  return new Response(null, { status: 302, headers });
}
