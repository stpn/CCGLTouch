//
//  MyCinderGLView.mm
//  CCGLTouchMultitouch example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import "MyCinderGLView.h"

#include "cinder/Rand.h"


@implementation MyCinderGLView

/**
 *	The superclass setup method
 */

- (void)setup
{
	[super setup];
    
    // init values
    [self enableMultiTouch];
    mTouchFlag = YES;
}



/**
 *  The superclass draw method
 */

- (void)draw {
	gl::enableAlphaBlending();
	gl::clear( Color( 0.1f, 0.1f, 0.1f ) );
    
	for( map<uint32_t,TouchPoint>::const_iterator activeIt = mActivePoints.begin(); activeIt != mActivePoints.end(); ++activeIt ) {
		activeIt->second.draw();
	}
    
	for( list<TouchPoint>::iterator dyingIt = mDyingPoints.begin(); dyingIt != mDyingPoints.end(); ) {
		dyingIt->draw();
		if( dyingIt->isDead() )
			dyingIt = mDyingPoints.erase( dyingIt );
		else
			++dyingIt;
	}
	
	// draw yellow circles at the active touch points
	gl::color( Color( 1, 1, 0 ) );
	for( vector<TouchEvent::Touch>::const_iterator touchIt = [self getActiveTouches].begin(); touchIt != [self getActiveTouches].end(); ++touchIt )
        if (mTouchFlag)
            gl::drawStrokedCircle( touchIt->getPos(), 20.0f );
}



/**
 *
 */

- (void)turnActiveTouchesOn:(BOOL)flag
{
    mTouchFlag = flag;
}



/**
 *  touch events
 */

- (void)touchesBegan:(ci::app::TouchEvent)event
{
    console() << "Began: " << event << std::endl;
	for( vector<TouchEvent::Touch>::const_iterator touchIt = event.getTouches().begin(); touchIt != event.getTouches().end(); ++touchIt ) {
		Color newColor( CM_HSV, Rand::randFloat(), 1, 1 );
		mActivePoints.insert( make_pair( touchIt->getId(), TouchPoint( touchIt->getPos(), newColor ) ) );
	}
}

- (void)touchesMoved:(ci::app::TouchEvent)event
{    
	for( vector<TouchEvent::Touch>::const_iterator touchIt = event.getTouches().begin(); touchIt != event.getTouches().end(); ++touchIt )
		mActivePoints[touchIt->getId()].addPoint( touchIt->getPos() );
}

- (void)touchesEnded:(ci::app::TouchEvent)event
{
    console() << "Ended: " << event << std::endl;
	for( vector<TouchEvent::Touch>::const_iterator touchIt = event.getTouches().begin(); touchIt != event.getTouches().end(); ++touchIt ) {
		mActivePoints[touchIt->getId()].startDying();
		mDyingPoints.push_back( mActivePoints[touchIt->getId()] );
		mActivePoints.erase( touchIt->getId() );
	}
}

@end
