import {
    collections,
    objects,
    predicates,
    teams,
} from "./deps.ts";
// import * as v from "https://esm.sh/valibot@0.13.1";
import { redirect } from "./redirect.ts";
import { pair } from "./pair.ts";

const { serve } = Deno;

function handler(req: Request): Response {
    const { pathname, searchParams } = new URL(req.url);
    // pathname?separator&length
    switch (pathname) {
        case "/word-pairs":
            return handleWords();
        case "/team-pairs":
            return handleTeams();
        case "/collection-pairs":
            return handleCollections();
        default:
            return redirect("/word-pairs");
    }
}

// predicate-objects
function handleWords() {
    return new Response(pair(predicates, objects), { status: 200 });
}
// predicates-collections
function handleCollections() {
    return new Response(pair(predicates, collections), { status: 200 });
}
// predicates-teams
function handleTeams() {
    return new Response(pair(predicates, teams), { status: 200 });
}

// Learn more at https://deno.land/manual/examples/module_metadata#concepts
if (import.meta.main) {
    serve(handler);
}
