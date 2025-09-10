{ conf-target
, name-target
, pkgs
}:
let
	musl-src = builtins.fetchGit {
		url = "https://github.com/kraj/musl.git";
		rev = "0784374d561435f7c787a555aeab8ede699ed298";
		shallow = true;
	};
in pkgs.stdenvNoCC.mkDerivation {
	name = "libc-${name-target}";

	src = musl-src;

	nativeBuildInputs = [ pkgs.clang pkgs.lld pkgs.coreutils ];

	configurePhase = ''
		CC="clang --target=${conf-target}-linux-musl" \
			CFLAGS="-O2" \
			LDFLAGS="-fuse-ld=lld" \
			./configure --target=${conf-target}
	'';

	buildPhase = ''
		make -j lib/libc.so
	'';

	installPhase = ''
		mkdir -p "$out/lib"
		cp lib/libc.so "$out/lib/libc.so"
	'';
}
