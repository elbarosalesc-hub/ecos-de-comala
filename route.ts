import { integer, sqliteTable, text } from "drizzle-orm/sqlite-core";

export const profiles = sqliteTable("profiles", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  identity: text("identity").notNull().unique(),
  displayName: text("display_name").notNull(),
  role: text("role").notNull(),
  course: text("course").notNull().default(""),
  createdAt: integer("created_at").notNull(),
});

export const rooms = sqliteTable("rooms", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  code: text("code").notNull().unique(),
  name: text("name").notNull(),
  teacherIdentity: text("teacher_identity").notNull(),
  active: integer("active", { mode: "boolean" }).notNull().default(true),
  createdAt: integer("created_at").notNull(),
});

export const scores = sqliteTable("scores", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  roomCode: text("room_code").notNull(),
  identity: text("identity").notNull(),
  displayName: text("display_name").notNull(),
  score: integer("score").notNull().default(0),
  memoryScore: integer("memory_score").notNull().default(0),
  station: integer("station").notNull().default(0),
  skill: text("skill").notNull().default("General"),
  updatedAt: integer("updated_at").notNull(),
});

export const progress = sqliteTable("progress", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  identity: text("identity").notNull(),
  displayName: text("display_name").notNull(),
  module: text("module").notNull(),
  skill: text("skill").notNull(),
  score: integer("score").notNull(),
  total: integer("total").notNull(),
  updatedAt: integer("updated_at").notNull(),
});
