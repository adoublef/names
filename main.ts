import { collections, objects, predicates, teams } from './deps.ts';
import { redirect } from './redirect.ts';
import { pairs } from './pairs.ts';

const { serve } = Deno;

function handler(req: Request): Response {
  const { pathname, searchParams } = new URL(req.url);
  // pathname?separator&length
  switch (pathname) {
    case '/word-pairs':
      return handleWords();
    case '/team-pairs':
      return handleTeams();
    case '/collection-pairs':
      return handleCollections();
    default:
      return redirect('/word-pairs');
  }
}

// predicate-objects
function handleWords() {
  return new Response(pairs(predicates, objects));
}
// predicates-collections
function handleCollections() {
  return new Response(pairs(predicates, collections));
}
// predicates-teams
function handleTeams() {
  return new Response(pairs(predicates, teams));
}

// Learn more at https://deno.land/manual/examples/module_metadata#concepts
if (import.meta.main) {
  serve(handler);
}
