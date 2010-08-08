//
//  MapTileType.h
//  GhostGuy
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//


typedef enum {
	
	MAP_TILE_WALL_HORIZ		= 0x00,
	MAP_TILE_WALL_VERTI		= 0x33,
	MAP_TILE_WALL_TOP_LEFT	= 0x66,
	MAP_TILE_WALL_TOP_RIGHT	= 0x99,
	MAP_TILE_WALL_BTM_LEFT	= 0xCC,
	MAP_TILE_WALL_BTM_RIGHT	= 0xFF,
} MapTileWall;


typedef enum {
	
	MAP_TILE_EMPTY_SPACE	= 0x00,
	MAP_TILE_SMALL_DOT		= 0x33,
	MAP_TILE_BIG_DOT		= 0x99,
} MapTileWalkable;


typedef enum {
	
	MapTileEmptySpace,
	MapTileSmallDot,
	MapTileBigDot,
	MapTileTopLeftWall,
	MapTileTopRightWall,
	MapTileBottomLeftWall,
	MapTileBottomRightWall,
	MapTileHorizontalWall,
	MapTileVerticalWall,
	MapTileHighlight /* for AI path testing */
} MapTileType;