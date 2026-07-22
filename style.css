type Payload = Record<string, unknown>;
type D1 = { prepare:(query:string)=>any; batch:(statements:any[])=>Promise<unknown> };

async function database():Promise<D1> {
  const { env } = await import("cloudflare:workers");
  return env.DB as D1;
}

function identity(request: Request, payload?: Payload) {
  return request.headers.get("oai-authenticated-user-email") || String(payload?.clientId || "");
}

async function init() {
  const db = await database();
  await db.batch([
    db.prepare("CREATE TABLE IF NOT EXISTS profiles (id INTEGER PRIMARY KEY AUTOINCREMENT, identity TEXT NOT NULL UNIQUE, display_name TEXT NOT NULL, role TEXT NOT NULL, course TEXT NOT NULL DEFAULT '', created_at INTEGER NOT NULL)"),
    db.prepare("CREATE TABLE IF NOT EXISTS rooms (id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT NOT NULL UNIQUE, name TEXT NOT NULL, teacher_identity TEXT NOT NULL, active INTEGER NOT NULL DEFAULT 1, created_at INTEGER NOT NULL)"),
    db.prepare("CREATE TABLE IF NOT EXISTS scores (id INTEGER PRIMARY KEY AUTOINCREMENT, room_code TEXT NOT NULL, identity TEXT NOT NULL, display_name TEXT NOT NULL, score INTEGER NOT NULL DEFAULT 0, memory_score INTEGER NOT NULL DEFAULT 0, station INTEGER NOT NULL DEFAULT 0, skill TEXT NOT NULL DEFAULT 'General', updated_at INTEGER NOT NULL)"),
    db.prepare("CREATE UNIQUE INDEX IF NOT EXISTS scores_room_identity_idx ON scores(room_code, identity)"),
    db.prepare("CREATE TABLE IF NOT EXISTS progress (id INTEGER PRIMARY KEY AUTOINCREMENT, identity TEXT NOT NULL, display_name TEXT NOT NULL, module TEXT NOT NULL, skill TEXT NOT NULL, score INTEGER NOT NULL, total INTEGER NOT NULL, updated_at INTEGER NOT NULL)"),
  ]);
}

export async function GET(request: Request) {
  await init();
  const db = await database();
  const url = new URL(request.url);
  const action = url.searchParams.get("action");
  const code = (url.searchParams.get("code") || "").toUpperCase();
  if (action === "leaderboard") {
    const result = await db.prepare("SELECT display_name AS displayName, score, memory_score AS memoryScore, station, skill, updated_at AS updatedAt FROM scores WHERE room_code = ? ORDER BY (score + memory_score) DESC, updated_at ASC LIMIT 60").bind(code).all();
    return Response.json({ rows: result.results });
  }
  if (action === "progress") {
    const teacher = identity(request);
    const result = await db.prepare("SELECT p.display_name AS displayName, p.module, p.skill, p.score, p.total, p.updated_at AS updatedAt FROM progress p JOIN rooms r ON r.teacher_identity = ? WHERE p.identity IN (SELECT identity FROM scores WHERE room_code = r.code) ORDER BY p.updated_at DESC LIMIT 200").bind(teacher).all();
    return Response.json({ rows: result.results });
  }
  return Response.json({ error: "Acción no válida" }, { status: 400 });
}

export async function POST(request: Request) {
  await init();
  const db = await database();
  const body = await request.json() as Payload;
  const action = String(body.action || "");
  const who = identity(request, body);
  if (!who) return Response.json({ error: "Identidad requerida" }, { status: 401 });
  const now = Date.now();
  if (action === "register") {
    const name = String(body.displayName || "").trim().slice(0, 60);
    const role = body.role === "teacher" ? "teacher" : "student";
    const course = String(body.course || "").trim().slice(0, 40);
    if (!name) return Response.json({ error: "Nombre requerido" }, { status: 400 });
    await db.prepare("INSERT INTO profiles(identity,display_name,role,course,created_at) VALUES(?,?,?,?,?) ON CONFLICT(identity) DO UPDATE SET display_name=excluded.display_name, role=excluded.role, course=excluded.course").bind(who,name,role,course,now).run();
    return Response.json({ profile: { identity: who, displayName:name, role, course } });
  }
  if (action === "createRoom") {
    const code = Math.random().toString(36).slice(2,7).toUpperCase();
    const name = String(body.name || "Desafío Pedro Páramo").slice(0,80);
    await db.prepare("INSERT INTO rooms(code,name,teacher_identity,active,created_at) VALUES(?,?,?,?,?)").bind(code,name,who,1,now).run();
    return Response.json({ room: { code, name } });
  }
  if (action === "join" || action === "submit") {
    const code = String(body.code || "").toUpperCase();
    const room = await db.prepare("SELECT code,name,active FROM rooms WHERE code=?").bind(code).first();
    if (!room) return Response.json({ error: "Sala no encontrada" }, { status: 404 });
    const displayName = String(body.displayName || "Estudiante").slice(0,60);
    const score = Number(body.score || 0), memoryScore = Number(body.memoryScore || 0), station = Number(body.station || 0);
    await db.prepare("INSERT INTO scores(room_code,identity,display_name,score,memory_score,station,skill,updated_at) VALUES(?,?,?,?,?,?,?,?) ON CONFLICT(room_code,identity) DO UPDATE SET display_name=excluded.display_name, score=MAX(scores.score,excluded.score), memory_score=MAX(scores.memory_score,excluded.memory_score), station=MAX(scores.station,excluded.station), skill=excluded.skill, updated_at=excluded.updated_at").bind(code,who,displayName,score,memoryScore,station,String(body.skill||"General"),now).run();
    return Response.json({ room });
  }
  if (action === "progress") {
    await db.prepare("INSERT INTO progress(identity,display_name,module,skill,score,total,updated_at) VALUES(?,?,?,?,?,?,?)").bind(who,String(body.displayName||"Estudiante"),String(body.module||"Juego"),String(body.skill||"General"),Number(body.score||0),Number(body.total||0),now).run();
    return Response.json({ ok:true });
  }
  return Response.json({ error: "Acción no válida" }, { status: 400 });
}
