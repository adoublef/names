import { STATUS_CODE } from './deps.ts';
import { assert, assertEquals } from './dev_deps.ts';
import { handler } from './handler.ts';

Deno.test('handler', async (t) => {
  await t.step('Default', async () => {
    const req = new Request('http://localhost/');
    const res = await handler(req);
    assertEquals(res.status, STATUS_CODE.OK);
    const resBody = await res.text();
    assert(resBody.includes('-'));
  });
  await t.step('Hyphen', async () => {
    const req = new Request('http://localhost/?separator=hyphen');
    const res = await handler(req);
    assertEquals(res.status, STATUS_CODE.OK);
    const resBody = await res.text();
    assert(resBody.includes('-'));
  });
  await t.step('Underscore', async () => {
    const req = new Request('http://localhost/?separator=underscore');
    const res = await handler(req);
    assertEquals(res.status, STATUS_CODE.OK);
    const resBody = await res.text();
    assert(resBody.includes('_'));
  });
  await t.step('Period', async () => {
    const req = new Request('http://localhost/?separator=period');
    const res = await handler(req);
    assertEquals(res.status, STATUS_CODE.OK);
    const resBody = await res.text();
    assert(resBody.includes('.'));
  });
  await t.step('BadRequest', async () => {
    const req = new Request('http://localhost/?separator=unknown');
    const res = await handler(req);
    assertEquals(res.status, STATUS_CODE.BadRequest);
  });
  await t.step('Words', async () => {
    const req = new Request('http://localhost/');
    const res = await handler(req);
    assertEquals(res.status, STATUS_CODE.OK);
  });
  await t.step('Teams', async () => {
    const req = new Request('http://localhost/teams');
    const res = await handler(req);
    assertEquals(res.status, STATUS_CODE.OK);
  });
  await t.step('Collections', async () => {
    const req = new Request('http://localhost/collections');
    const res = await handler(req);
    assertEquals(res.status, STATUS_CODE.OK);
  });
  await t.step('NotFound', async () => {
    const req = new Request('http://localhost/unknown');
    const res = await handler(req);
    assertEquals(res.status, STATUS_CODE.NotFound);
  });
});
