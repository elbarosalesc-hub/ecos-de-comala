CREATE TABLE `profiles` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`identity` text NOT NULL,
	`display_name` text NOT NULL,
	`role` text NOT NULL,
	`course` text DEFAULT '' NOT NULL,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `profiles_identity_unique` ON `profiles` (`identity`);--> statement-breakpoint
CREATE TABLE `progress` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`identity` text NOT NULL,
	`display_name` text NOT NULL,
	`module` text NOT NULL,
	`skill` text NOT NULL,
	`score` integer NOT NULL,
	`total` integer NOT NULL,
	`updated_at` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `rooms` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`code` text NOT NULL,
	`name` text NOT NULL,
	`teacher_identity` text NOT NULL,
	`active` integer DEFAULT true NOT NULL,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `rooms_code_unique` ON `rooms` (`code`);--> statement-breakpoint
CREATE TABLE `scores` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`room_code` text NOT NULL,
	`identity` text NOT NULL,
	`display_name` text NOT NULL,
	`score` integer DEFAULT 0 NOT NULL,
	`memory_score` integer DEFAULT 0 NOT NULL,
	`station` integer DEFAULT 0 NOT NULL,
	`skill` text DEFAULT 'General' NOT NULL,
	`updated_at` integer NOT NULL
);
