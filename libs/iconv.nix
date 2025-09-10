{ pkgs
, zig
}:
let
	iconv-src = builtins.fetchTarball {
		url = "https://ftp.gnu.org/gnu/libiconv/libiconv-1.18.tar.gz";
		sha256 = "0n6v0n0xiwgglmrbzlxxhdi7lf6iwdbbmi4m2dz44mqv0v6khbq5";
	};
in pkgs.stdenvNoCC.mkDerivation {
	name = "libiconv";

	src = iconv-src;

	nativeBuildInputs = [ zig pkgs.coreutils ];

	configurePhase = ''
		CC=zig-cc-arm64-macos \
			LD=zig-cc-arm64-macos \
			AR="${zig}/zig ar" \
			CFLAGS="-O2" \
			./configure --host=aarch64-apple-darwin --enable-shared=yes
	'';

	buildPhase = ''
		make -j
	'';

	installPhase = ''
		mkdir -p "$out/lib"
		cp lib/.libs/libiconv.dylib "$out/lib/libiconv.dylib"
	'';
}
