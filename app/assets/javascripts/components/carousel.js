var toolbox  = require( 'compose-toolbox' ),
    Event    = toolbox.event,
    Callback = toolbox.event.callback,
    carouselSelector = '.carousel',
    stepCallbacks,
    carousels

// Remove any existing callbacks and registered carousels
function reset () {

  stepCallbacks = { next: [] }
  carousels = []

}

function newCarousel( carousel ) {

  if ( !carousel ) return

  var steps     = toolbox.slice( carousel.querySelectorAll( '.carousel-step' ) ),
      stepIndex = 0,
      navItems  = ''

  if ( steps.length == 0 ) return

  steps.forEach( function( step, index ) { 

    // disable all steps but the current step
    step.classList.toggle('inactive', step != currentStep())
    step.disabled     = step != currentStep()
    step.dataset.step = index

  })

  if ( carousel.dataset.nav ) {
    var nav = '<nav class="progressive-carousel-nav">'

    steps.forEach( function( step, index ) {
      nav += '<a href="#" class="progressive-carousel-nav-item" data-step="'+( index + 1 )+'">'
      nav += step.dataset.nav || "Step " + ( index + 1 )
      nav += '</a> '
    })

    nav += '</nav>'

    carousel.insertAdjacentHTML( 'afterbegin', nav )
  }

  show()

  function previousStep ()  { return steps[ stepIndex - 1] }
  function currentStep ()   { return steps[ stepIndex ] }
  function nextStep ()      { return steps[ stepIndex + 1] }
  function active ()        { return currentStep() && !currentStep().disabled }
 
  // Move to next step
  function forward () {
    showStep( stepIndex + 1 )
  }

  // Move to next step
  function back () {
    showStep( stepIndex - 1 )
  }

  // Accepts a step index
  function showStep ( index ) {

    index = Number( index )

    // Get the step from the index
    var step = steps[ index ]

    // Don't go to a non-existant step, or the current step
    if ( step && step != currentStep() ) {

      var direction = ( stepIndex < index ) ? 'forward' : 'reverse'

      console.log(index, direction)

      // If a step is currently active
      // dismiss it before going to the specified step
      if ( active() ) {
        return dismiss( function() { showStep( index ) }, direction )
      }

      stepIndex = index

      show( direction )

    }
  }
  
  // Hide a passed step and move to the next
  function dismiss ( callback, direction ) {
    direction = direction || 'forward'

    currentStep().classList.remove( 'active', 'enter' )
    currentStep().classList.add( 'exit' )
    currentStep().dataset.direction = direction

    Event.afterAnimation( currentStep(), function() {
      disable()

      if ( typeof callback === 'function' ) callback()

    })

  }

  function revisit ( callback, direction ) {

    if ( !active() ) {
      direction = direction || 'reverse'

      currentStep().classList.remove( 'exit', 'passed', 'inactive' )
      currentStep().classList.add( 'active', 'enter' )
      currentStep().dataset.direction = direction

      disableOtherSteps()

      Event.afterAnimation( currentStep(), function() {
        currentStep().classList.remove( 'enter' )
        if ( typeof callback === 'function' ) callback()
      })
    }
  }

  // Show the carousel-step
  function show ( direction ) {

    disableOtherSteps()
    currentStep().classList.remove( 'passed', 'inactive' )
    currentStep().dataset.direction = direction
    currentStep().classList.add( 'active', 'enter' )

    // focus on the first input
    var firstInput = currentStep().querySelector( 'input:not([hidden]), textarea, select' )
    if ( firstInput ) firstInput.focus()

    setNav()

    Event.afterAnimation( currentStep(), function() {
      currentStep().classList.remove( 'enter' )
    })

  }

  // Disable a carousel step after it has been hidden
  function disable () {

    currentStep().disabled = true
    currentStep().classList.add( 'passed', 'inactive' )
    currentStep().classList.remove( 'enter', 'exit' )

  }

  function setNav () {
    toolbox.each( carousel.querySelectorAll( 'nav [data-step]' ), function ( nav ) {

      if ( nav.dataset.step < stepIndex + 1 ) {
        nav.classList.remove( 'here', 'next' )
        nav.classList.add( 'previous', 'passed' )
      }

      if ( nav.dataset.step == stepIndex + 1 ) {
        nav.classList.remove( 'previous', 'next' )
        nav.classList.add( 'here' )
      }

      if ( nav.dataset.step > stepIndex + 1 ) {
        nav.classList.remove( 'previous', 'here' )
        nav.classList.add( 'next' )
      }

    })
  }

  function enableAllSteps () {
    steps.forEach( function( fieldset ) {
      fieldset.disabled = false
    })
  }

  function disableOtherSteps () {
    steps.forEach( function( fieldset ) {
      fieldset.disabled = fieldset != currentStep() 
    })
  }

  carousels.push( function( event, trigger ) {
    console.log( event, trigger )
    var target = event.currentTarget

    if ( trigger === 'back' ) {
      event.preventDefault()

      back()
    }
    
    if ( trigger === 'show-step' ) {
      event.preventDefault()

      //if ( toolbox.matches( target, '.previous, .passed, .passed + a' ) )
      showStep( target.dataset.step - 1 )

    } else if ( trigger === 'next' ) {

      // Continue if submit was triggered on this carousel
      // and no invalid fields are found

      var carouselEl = ( target.classList.contains('carousel') ) ? target : toolbox.getClosest( target, '.carousel')

      if ( carousel == carouselEl && !currentStep().querySelector( ':invalid' ) ) {

        // Get the function which triggers callbacks
        var fireCallbacks = getCallbacks( carousel )

        // This is the last stop, be sure all steps are enabled!
        if ( !nextStep() ) enableAllSteps()
        else disableOtherSteps()

        // If there are callbacks, let them handle this!
        if ( fireCallbacks ) {

          // Since there are callbacks, stop the submission event
          event.preventDefault()

          fireCallbacks( event, {
            current: currentStep(),   // Valid fieldset or step element
            carousel: carousel,       // Parent carousel element
            forward:  forward,        // Call forward() to move to the next step
            dismiss:  dismiss,        // Hide and disable current step
            revisit:  revisit,        // Revisit current disabled step
            showStep: showStep,       // Show a specific step by index (0 based)
            complete: !nextStep(),    // is this is the final carousel step?
            carouselData: toolbox.carouselData( currentStep() ) // pass carouselData for current step
          })
        }

        // No callbacks? If there's a next step, stop submission and proceed
        else if ( nextStep() ) {
          event.preventDefault()
          forward()
        }
      }
    }
  })
}

function fire ( event, type ) {
  carousels.forEach( function( fn ) { fn( event, type ) })
}

// Returns a function which triggers callbacks
function getCallbacks ( carousel, type ) {

  type = type || 'next'
  var callbacks = [], cb;

  stepCallbacks[ type ].forEach( function( test ) {
     if ( cb = test( carousel ) ) {
       callbacks.push( cb )
     }
  })

  // Return a function which can trigger all callbacks
  // or returns fallse if none are called

  if ( callbacks.length )
    return function() {
      var args = toolbox.slice( arguments )

      callbacks.forEach( function( callback ) {
        callback.apply( callback, args ) }) }

  else return false
}

function next ( el, callback ) {
  on( el, 'next', callback )
}

function on ( el, event, callback ) {

  // Accept events list as an object e.g. { next: callback }
  if ( typeof event === 'object' ) {
    for ( type in event ) {
      on( el, type, event[ type ] )
    }
  }

  else if ( stepCallbacks[ event ] ) {

    // Only allow access to a callback if the carousel matches
    var filter = function( carousel ) {
      if ( carousel == el ) return callback
    }

    // Add the test wrapper function to the callback list
    stepCallbacks[ event ].push( filter )
  }
}

Event.ready( function(){
  reset()

  // Add bubbling so we can listen for submission
  Event.bubbleFormEvents()

  var nextSelector = carouselSelector + ' [type=submit], ' + carouselSelector + ' .next-step'
  var backSelector = carouselSelector + ' .back-step'
  var navSelector  = '.carousel-nav-item[data-step]'

  Event.on( document, 'click', nextSelector , fire, 'next' )
  Event.on( document, 'click', backSelector , fire, 'back' )
  Event.on( document, 'click', navSelector  , fire, 'show-step' )
// insert core styling for hiding inactive and passed carousel-steps
  document.head.insertAdjacentHTML( 'beforeend', "<style>\
.carousel-step.inactive, .carousel-step.passed {\
  position: absolute !important;\
  top:      -9999px  !important;\
  left:     -9999px  !important;\
  left:     0        !important;\
  right:    0        !important; }\
</style>" )

  Event.change( function() {
    reset()

    toolbox.each( document.querySelectorAll( carouselSelector ), function( el ) {
      newCarousel( el )
    })
  })
})

module.exports = {
  next: next,
  new: newCarousel
}
