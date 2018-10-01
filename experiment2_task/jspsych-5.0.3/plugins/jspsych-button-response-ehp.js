/**
 * jspsych-button-response
 * Josh de Leeuw
 *
 * plugin for displaying a stimulus and getting a keyboard response
 *
 * documentation: docs.jspsych.org
 *
 **/

jsPsych.plugins["button-response-ehp"] = (function() {

  var plugin = {};

  plugin.trial = function(display_element, trial) {

    // default trial parameters
    trial.button_html = trial.button_html || '<button class="jspsych-btn">%choice%</button>';
    trial.response_ends_trial = (typeof trial.response_ends_trial === 'undefined') ? true : trial.response_ends_trial;
    trial.timing_stim = trial.timing_stim || -1; // if -1, then show indefinitely
    trial.timing_response = trial.timing_response || -1; // if -1, then wait for response forever
    trial.is_html = (typeof trial.is_html === 'undefined') ? false : trial.is_html;
    trial.prompt = (typeof trial.prompt === 'undefined') ? "" : trial.prompt;

    // if any trial variables are functions
    // this evaluates the function and replaces
    // it with the output of the function
    trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);

    // this array holds handlers from setTimeout calls
    // that need to be cleared if the trial ends early
    var setTimeoutHandlers = [];
 	 	var part = 0;
    // var choice = -1;

    setup_display1 = function(){
    // display stimulus
    if (!trial.is_html) {
      display_element.append($('<img>', {
        src: trial.stimulus,
        id: 'jspsych-button-response-stimulus',
        class: 'block-center'
      }));
    } else {
      display_element.append($('<div>', {
        html: trial.stimulus,
        id: 'jspsych-button-response-stimulus',
        class: 'block-center'
      }));
    }

    //display buttons
    var buttons = [];
    if (Array.isArray(trial.button_html)) {
      if (trial.button_html.length == trial.choices.length) {
        buttons = trial.button_html;
      } else {
        console.error('Error in button-response plugin. The length of the button_html array does not equal the length of the choices array');
      }
    } else {
      for (var i = 0; i < trial.choices.length; i++) {
        buttons.push(trial.button_html);
      }
    }
    //show prompt if there is one
    if (trial.prompt !== "") {
      display_element.append(trial.prompt);
    }
    display_element.append('<div id="jspsych-button-response-btngroup" class="center-content block-center"></div>')
    for (var i = 0; i < trial.choices.length; i++) {
      var str = buttons[i].replace(/%choice%/g, trial.choices[i]);
      $('#jspsych-button-response-btngroup').append(
        $(str).attr('id', 'jspsych-button-response-button' + i).data('choice', i).addClass('jspsych-button-response-button').on('click', function(e) {
          var choice = $('#' + this.id).data('choice');
          after_response(choice);
        })
      );
    }


  }

	var setup_display2 = function(){
		display_element.append($('<div>',{
			id: 'jspsych-tree-stim-no-response',
			style: 'h1',
		}));
	}

	var display_stimuli = function(stage){
		if (stage == 2){
      // console.log('choice before response is  ' + choice)
      if (keychoice != 0){
        $('#jspsych-tree-stim-no-response').append('Incorrect. Try again!');
      } else{
        $('#jspsych-tree-stim-no-response').append('Correct!');
      }

		}
	}
    // store response
    var response = {
      rt: -1,
      button: -1
    };

    //store correct choice for practice
    // var correct_prac = []
    //
    //   if (choice == 0){
    //     correct_prac = 'correct';
    //     } else {
    //       correct_prac = 'wrong';
    //     };
    //     console.log('correct_prac is '+ correct_prac)
    //     console.log('choice is '+ choice)

    // start time
    var start_time = 0;

    // function to handle responses by the subject
    function after_response(choice) {
keychoice = choice
console.log(choice)
      // measure rt
      var end_time = Date.now();
      var rt = end_time - start_time;
      response.button = choice;
      response.rt = rt;

      // disable all the buttons after a response
      $('.jspsych-button-response-button').off('click').attr('disabled', 'disabled');

      // after a valid response, the stimulus will have the CSS class 'responded'
      // which can be used to provide visual feedback that a response was recorded
      $("#jspsych-button-response-stimulus").addClass('responded');
			if (part == 1){
				display_element.html('');
				setup_display2();
				display_stimuli(2);
        console.log('choice after response is  ' + choice)
          var feedback_time = setTimeout(function(){

          if (choice != 0){
            console.log('incorrect')
            part = 0
            display_element.html('');
            next_part();
          } else {
            console.log('correct')
             end_trial();
           }
         },2000);
         setTimeoutHandlers.push(feedback_time);
        }

      // disable all the buttons after a response
      $('.jspsych-button-response-button').off('click').attr('disabled', 'disabled');
      //
      // if (trial.response_ends_trial) {
      //   end_trial();
      // }
    };

    // function to end trial when it is time
    function end_trial() {

      // kill any remaining setTimeout handlers
      for (var i = 0; i < setTimeoutHandlers.length; i++) {
        clearTimeout(setTimeoutHandlers[i]);
      }

      // gather the data to store for the trial
      var trial_data = {
        "rt": response.rt,
        "stimulus": trial.stimulus,
        "button_pressed": response.button
      };

      // clear the display
      display_element.html('');

      // move on to the next trial
      jsPsych.finishTrial(trial_data);
    };

    // start timing
    start_time = Date.now();

    // hide image if timing is set
    if (trial.timing_stim > 0) {
      var t1 = setTimeout(function() {
        $('#jspsych-button-response-stimulus').css('visibility', 'hidden');
      }, trial.timing_stim);
      setTimeoutHandlers.push(t1);
    }

    // end trial if time limit is set

		next_part = function(){
			part = part + 1
			setup_display1();


			console.log("work this time")

			    // if (trial.timing_response > 0) {
			    //   var t2 = setTimeout(function() {
			    //     end_trial();
			    //   }, trial.timing_response);
			    //   setTimeoutHandlers.push(t2);
			    // }
		};
		next_part();

  };

  return plugin;
})();
