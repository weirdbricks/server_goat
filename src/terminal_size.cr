# code from: https://forum.crystal-lang.org/t/how-to-get-the-width-of-the-terminal/5621/2
# repo: https://chiselapp.com/user/MistressRemilia/repository/libremiliacr/index

lib LibC
    # Bare minimum for the ioctl stuff we need

    TIOCGWINSZ = 0x5413u32

    struct Winsize
      ws_row    : UInt16
      ws_col    : UInt16
      ws_xpixel : UInt16
      ws_ypixel : UInt16
    end

    fun ioctl(fd : LibC::Int, what : LibC::ULong, ...) : LibC::Int
end

# Gets the width and height of the terminal.
def getWinSize : Tuple(UInt16, UInt16)
  thing = LibC::Winsize.new
  LibC.ioctl(STDOUT.fd, LibC::TIOCGWINSZ, pointerof(thing))
  {thing.ws_row, thing.ws_col}
end

#height, width = getWinSize

#puts height,width
