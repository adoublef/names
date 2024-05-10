import { STATUS_CODE, STATUS_TEXT, StatusCode } from './deps.ts';
import { collections, objects, predicates, teams } from './deps.ts';
import { isSeparator, SEPARATOR } from './separator.ts';
import { pairs } from './pairs.ts';

// deno-lint-ignore require-await
export async function handler(req: Request): Promise<Response> {
  const { pathname, searchParams } = new URL(req.url);
  const separatorText = searchParams.get('separator') ?? 'hyphen';
  if (!isSeparator(separatorText)) {
    return handleError(STATUS_CODE.BadRequest);
  }
  const separator = SEPARATOR[separatorText];
  const predicatesOf = pairs(predicates, separator);
  switch (pathname) {
    case '/':
    case '/words':
      return new Response(predicatesOf(objects));
    case '/teams':
      return new Response(predicatesOf(teams));
    case '/collections':
      return new Response(predicatesOf(collections));
  }

  return handleError(STATUS_CODE.NotFound);
}

function handleError(status: StatusCode): Response {
  const statusText = STATUS_TEXT[status];
  return new Response(statusText, { status, statusText });
}
