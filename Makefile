all:
	premake gmake
	$(MAKE) -C build config=debug

clean:
	$(MAKE) -C build clean
	rm -rf build
