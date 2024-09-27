const std = @import("std");

const BoardSize: u8 = 8;

const Piece=enum {
    None,
    Pawn,
    Knight,
    Bishop,
    Rook,
    Queen,
    King,
};

const Color = enum {
    None,
    Black,
    White,
};

const GridPosition2D = struct {
    x: u8,
    y: u8,
    pub fn init( x: u8, y: u8) GridPosition2D {
        return GridPosition2D{
            .x = x,
            .y = y,
        };
    }
};

const PieceInfo = struct {
    piece: Piece,
    position: GridPosition2D,
    color: Color,
    pub fn init(piece: Piece, color: Color, position: GridPosition2D) PieceInfo {
        return PieceInfo {
            .piece = piece,
            .color = color,
            .position = position,
        };
    }
    pub fn convert_to_ascii(self: PieceInfo) []const u8 {
        return switch(self.piece) {
            .None => ".",
            .Pawn => "P",
            .Rook => "R",
            .Knight => "N",
            .Bishop => "B",
            .Queen => "Q",
            .King => "K",
        };
    }
    pub fn move(self: *PieceInfo, new_position: GridPosition2D) void{
        self.position.x = new_position.x;
        self.position.y = new_position.y;
    }
};

const ChessBoard = struct{
    board: [BoardSize][BoardSize]PieceInfo,
    pub fn init() ChessBoard {
        var board: [BoardSize][BoardSize]PieceInfo = undefined;
        board[0][0] = PieceInfo.init(Piece.Rook, Color.Black, GridPosition2D.init(0, 0));
        board[0][1] = PieceInfo.init(Piece.Knight, Color.Black, GridPosition2D.init(0, 1));
        board[0][2] = PieceInfo.init(Piece.Bishop, Color.Black, GridPosition2D.init(0, 2));
        board[0][3] = PieceInfo.init(Piece.Queen, Color.Black, GridPosition2D.init(0, 3));
        board[0][4] = PieceInfo.init(Piece.King, Color.Black, GridPosition2D.init(0, 4));
        board[0][5] = PieceInfo.init(Piece.Bishop, Color.Black, GridPosition2D.init(0, 5));
        board[0][6] = PieceInfo.init(Piece.Knight, Color.Black, GridPosition2D.init(0, 6));
        board[0][7] = PieceInfo.init(Piece.Rook, Color.Black, GridPosition2D.init(0, 7));

        for(1..BoardSize-1) |i| {
            for(0..BoardSize) |j| {
                board[i][j] = switch(i) {
                    1 => PieceInfo.init(Piece.Pawn, Color.Black, GridPosition2D.init(1, @intCast(j))),
                    6 => PieceInfo.init(Piece.Pawn, Color.White, GridPosition2D.init(6, @intCast(j))),
                    else => PieceInfo.init(Piece.None, Color.None, GridPosition2D.init(@intCast(i), @intCast(j))),
                };
            }
        }
        board[7][0] = PieceInfo.init(Piece.Rook, Color.White, GridPosition2D.init(7, 0));
        board[7][1] = PieceInfo.init(Piece.Knight, Color.White, GridPosition2D.init(7, 1));
        board[7][2] = PieceInfo.init(Piece.Bishop, Color.White, GridPosition2D.init(7, 2));
        board[7][3] = PieceInfo.init(Piece.Queen, Color.White, GridPosition2D.init(7, 3));
        board[7][4] = PieceInfo.init(Piece.King, Color.White, GridPosition2D.init(7, 4));
        board[7][5] = PieceInfo.init(Piece.Bishop, Color.White, GridPosition2D.init(7, 5));
        board[7][6] = PieceInfo.init(Piece.Knight, Color.White, GridPosition2D.init(7, 6));
        board[7][7] = PieceInfo.init(Piece.Rook, Color.White, GridPosition2D.init(7, 7));

        return ChessBoard {
            //will it make a copy of the array?
            .board = board,
        };
    }
    pub fn print(self: ChessBoard) void {
        for (0..BoardSize) |i| {
            for (0..BoardSize) |j| {
               std.debug.print("{s}\t" , .{(self.board[i][j].convert_to_ascii())});
            }
            std.debug.print("\n", .{});
        }
    }
};
pub fn main() !void {
    var board = ChessBoard.init();
    board.print();
}