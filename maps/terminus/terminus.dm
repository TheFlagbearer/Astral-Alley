#if !defined(USING_MAP_DATUM)

	#include "terminus-1.dmm"
	#include "terminus-2.dmm"
	#include "terminus-3.dmm"
	#include "terminus-4.dmm"
	#include "terminus-5.dmm"
	#include "luna-1.dmm"
	#include "luna-2.dmm"
	#include "redspace-1.dmm"
	#include "redspace-2.dmm"
	#include "redspace-3.dmm"
	#include "terminus_defines.dm"
	#include "terminus_areas.dm"
	#include "terminus_elevator.dm"

	#define USING_MAP_DATUM /datum/map/terminus

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Terminus

#endif