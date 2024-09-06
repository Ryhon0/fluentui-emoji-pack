#!/usr/bin/rdmd

import std.conv;
import std.file;
import std.json;
import std.array;
import std.stdio;
import std.string;
import std.process;
import std.exception;
import std.parallelism;

void main()
{
	int emojiSize = 128;

	string packDir = "../pack/";
	if (exists(packDir))
		rmdirRecurse(packDir);

	mkdir(packDir);

	string threeDDir = packDir ~ "3d/";
	string colorDir = packDir ~ "color/";
	string flatDir = packDir ~ "flat/";
	mkdir(threeDDir);
	mkdir(colorDir);
	mkdir(flatDir);

	DirEntry[] emojis = dirEntries("../assets/", SpanMode.shallow).array;
	foreach (DirEntry e; taskPool.parallel(emojis, 128))
	{
		File metaFile = File(e ~ "/metadata.json", "r");
		char[] metaStr;
		metaStr.length = metaFile.size;
		metaFile.rawRead(metaStr);
		metaFile.close();

		JSONValue meta = parseJSON(metaStr);
		string unicode = meta["unicode"].str.replace(" ", "-");

		// TODO: skin color variations
		string prefix = "";
		if (exists(e ~ "/Default"))
			prefix = "/Default";

		string threeDImg = dirEntries(e ~ prefix ~ "/3D/", SpanMode.shallow).array[0];
		string colorImg = dirEntries(e ~ prefix ~ "/Color/", SpanMode.shallow).array[0];
		string flatImg = dirEntries(e ~ prefix ~ "/Flat/", SpanMode.shallow).array[0];

		copy(threeDImg, threeDDir ~ unicode ~ ".png");
		writeln("Rendering " ~ meta["glyph"].str ~ " (color)");
		execute([
			"inkscape", "-w", emojiSize.to!string, "-h", emojiSize.to!string,
			"--export-type", "png", colorImg, "--export-filename",
			colorDir ~ unicode ~ ".png"
		]);
		writeln("Rendering " ~ meta["glyph"].str ~ " (flat)");
		execute([
			"inkscape", "-w", emojiSize.to!string, "-h", emojiSize.to!string,
			"--export-type", "png", flatImg, "--export-filename",
			flatDir ~ unicode ~ ".png"
		]);
	}
}
