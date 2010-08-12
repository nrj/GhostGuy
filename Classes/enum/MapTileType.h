//
//  MapTileType.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


typedef enum {
	
	MAP_TILE_WALL_HORIZ		= 0x00,
	MAP_TILE_WALL_HORIZ_LFT = 0x11,
	MAP_TILE_WALL_HORIZ_RGT = 0x22,
	MAP_TILE_WALL_VERTI		= 0x33,
	MAP_TILE_WALL_VERTI_TOP = 0x44,
	MAP_TILE_WALL_VERTI_BTM = 0x55,
	MAP_TILE_WALL_TOP_LEFT	= 0xAA,
	MAP_TILE_WALL_TOP_RIGHT	= 0xBB,
	MAP_TILE_WALL_BTM_LEFT	= 0xCC,
	MAP_TILE_WALL_BTM_RIGHT	= 0xDD,
} MapTileWall;


typedef enum {
	
	MAP_TILE_EMPTY_SPACE	= 0x00,
	MAP_TILE_SMALL_DOT		= 0x33,
	MAP_TILE_BIG_DOT		= 0xFF,
} MapTileWalkable;


typedef enum {

	MAP_TILE_PACMAN_POSITION = 0x66,
	MAP_TILE_GHOST_POSITION = 0xFF
} MapTilePlayerPosition;


typedef enum {
	
	MapTileEmptySpace,
	MapTileSmallDot,
	MapTileBigDot,
	MapTileTopLeftWall,
	MapTileTopRightWall,
	MapTileBottomLeftWall,
	MapTileBottomRightWall,
	MapTileHorizontalWall,
	MapTileHorizontalLeftWall,
	MapTileHorizontalRightWall,
	MapTileVerticalWall,
	MapTileVerticalTopWall,
	MapTileVerticalBottomWall,
	MapTileHighlightSmallDot,
	MapTileHighlightBigDot/* for AI path testing */
	
} MapTileType;