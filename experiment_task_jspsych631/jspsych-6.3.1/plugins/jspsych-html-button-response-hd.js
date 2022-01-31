/**
 * jspsych-html-button-response
 * Josh de Leeuw
 *
 * plugin for displaying a stimulus and getting a button response
 *
 * documentation: docs.jspsych.org
 *
 **/

jsPsych.plugins["html-button-response-hd"] = (function() {

  var plugin = {};

  plugin.info = {
    name: 'html-button-response-hd',
    description: '',
    parameters: {
      stimulus: {
        type: jsPsych.plugins.parameterType.HTML_STRING,
        pretty_name: 'Stimulus',
        default: undefined,
        description: 'The HTML string to be displayed'
      },
      choices: {
        type: jsPsych.plugins.parameterType.STRING,
        pretty_name: 'Choices',
        default: undefined,
        array: true,
        description: 'The labels for the buttons.'
      },
      button_html: {
        type: jsPsych.plugins.parameterType.STRING,
        pretty_name: 'Button HTML',
        default: '<button class="jspsych-btn">%choice%</button>',
        array: true,
        description: 'The html of the button. Can create own style.'
      },
      prompt: {
        type: jsPsych.plugins.parameterType.STRING,
        pretty_name: 'Prompt',
        default: null,
        description: 'Any content here will be displayed under the button.'
      },
      stimulus_duration: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Stimulus duration',
        default: null,
        description: 'How long to hide the stimulus.'
      },
      trial_duration: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Trial duration',
        default: null,
        description: 'How long to show the trial.'
      },
      margin_vertical: {
        type: jsPsych.plugins.parameterType.STRING,
        pretty_name: 'Margin vertical',
        default: '0px',
        description: 'The vertical margin of the button.'
      },
      margin_horizontal: {
        type: jsPsych.plugins.parameterType.STRING,
        pretty_name: 'Margin horizontal',
        default: '8px',
        description: 'The horizontal margin of the button.'
      },
      response_ends_trial: {
        type: jsPsych.plugins.parameterType.BOOL,
        pretty_name: 'Response ends trial',
        default: true,
        description: 'If true, then trial will end when user responds.'
      },
      gold_image: {
        type: jsPsych.plugins.parameterType.HTML_STRING,
        pretty_name: 'Positive feedback image',
        default: null,
        description: 'Positive feedback.'
      },
      rock_image: {
        type: jsPsych.plugins.parameterType.HTML_STRING,
        pretty_name: 'Negative feedback image',
        default: null,
        description: 'Negative feedback.'
      },
      latent_intervention: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'latent intervention',
        default: null,
        description: 'Whether the agent intervened or not.'
      },
      exp_cond: {
        type: jsPsych.plugins.parameterType.STRING,
        pretty_name: 'Experimental condition',
        default: null,
        description: 'Experimental condition.'
      },
    }
  }

  plugin.trial = function(display_element, trial) {


        var prev_choice = jsPsych.data.get().last(1).filter({task_component: 'choice'}).select('response').values[0]
        //console.log('prev_choice is '+ prev_choice)

    // function to determine latent agent intervention or not (picks either the agent weights (1,0) or mine weights (x,1-x))

              function getWeightBen (intermediate){
                if (intermediate == [1]){ //pick the latent agent weights - for benev agent it is [1,0]
                  final_left = weights_agent_b;  // L side
                  final_right = weights_agent_b; // R side
                } else { //pick the mine probability weight [x,1-x]
                  final_left  = weights_free_left_b1; //L side
                  final_right = weights_free_right_b1; //R side
              }
              return [final_left, final_right];
              }


              function getWeightA (intermediate){
                if (intermediate == [1]){ //pick the latent agent weights - for adversarial agent it is [0,1]
                  final_left = weights_agent_a;  // L side
                  final_right = weights_agent_a; // R side
                } else { //pick the mine probability weight [x,1-x]
                  final_left  = weights_free_left_a1; //L side
                  final_right = weights_free_right_a1; //R side
              }
              return [final_left, final_right];
              }

              function getWeightRand (intermediate){
                if (intermediate == [1]){ //pick the latent agent weights - for random agent it is [0.5,0.5]
                  final_left = weights_agent_r;  // L side
                  final_right = weights_agent_r; // R side
                } else { //pick the mine probability weight [x,1-x]
                  final_left  = weights_free_left_r1; //L side
                  final_right = weights_free_right_r1; //R side
              }
              return [final_left, final_right];
              }


    // function to determine feedback (0 or 1)

                function getRandom (weights) {
                  var num = Math.random(),
                  s = 0,
                  lastIndex = weights.length - 1;

                  for (var i = 0; i < lastIndex; ++i) {
                    s += weights[i];
                    if (num < s) {
                      return results[i];
                    }
                  }

                  return results[lastIndex];
                };


                  if (trial.latent_intervention == 1){  //if the array determines that the latent agent should intervene, then use latent agent weights
                    var feedback_prob_post = 1;
                  } else{
                    feedback_prob_post = 0;
                  }

                  // Determine final weight depending on which condition you are in
                  if (trial.exp_cond == 'benevolent') { // if they chose the L mine
                    var final_weight = getWeightBen(feedback_prob_post); //final weight decision
                    var mine_weight_left = weights_free_left_b1;
                    var mine_weight_right = weights_free_right_b1;
                  } else if (trial.exp_cond == 'adversarial') {
                    var final_weight = getWeightA(feedback_prob_post); //final weight decision
                    var mine_weight_left = weights_free_left_a1;
                    var mine_weight_right = weights_free_right_a1; //final weight decision
                  } else if (trial.exp_cond == 'random'){
                    var final_weight = getWeightRand(feedback_prob_post); //final weight decision
                    var mine_weight_left = weights_free_left_r1;
                    var mine_weight_right = weights_free_right_r1; //final weight decision
                  }


                  if (prev_choice == 0) { // if they chose the L mine
                    input_weight = final_weight[0]; //use left side mine prob
                  } else {
                    input_weight = final_weight[1]; //use right side mine prob
                  }

                  //console.log('final_weight[0] is' + final_weight[0])
                  //console.log('final_weight[1] is' + final_weight[1])

                  var final_feedback = getRandom(input_weight) //get final feedback decision

                  //console.log('final feedback' + final_feedback)


//console.log("feedback_prob_post " + feedback_prob_post)
//console.log('final_weight ' + final_weight)
//console.log('final_left ' + final_left)
//console.log('final_right ' + final_right)
//console.log('input_weight ' + input_weight)









    // display choice stimulus
    var html = '<div id="jspsych-html-button-response-hd-stimulus">'+trial.stimulus+'</div>';



    // display feedback stimulus
    if(prev_choice == 0 && final_feedback == 0){ //if the prev choice was the left mine and feedback is 0
      html += '<img src="'+trial.rock_image+'" class ="fb_position_left">'; //rocks
      var trial_valence_string = 'Rocks';
      var bonus_sum = -1;

    } else if(prev_choice == 0 && final_feedback == 1){ //if the prev choice was the left mine and feedback is 1
      html += '<img src="'+trial.gold_image+'" class ="fb_position_left">'; //gold
      var trial_valence_string = 'Gold';
      var bonus_sum = 1;

   } else if(prev_choice == 1 && final_feedback == 0){ //if the prev choice was the right mine and feedback is 0
     html += '<img src="'+trial.rock_image+'" class ="fb_position_right">'; //rocks
     var trial_valence_string = 'Rocks';
     var bonus_sum = -1;

   } else if(prev_choice == 1 && final_feedback == 1){ //if the prev choice was the right mine and feedback is 1
     html += '<img src="'+trial.gold_image+'" class ="fb_position_right">'; //gold
     var trial_valence_string = 'Gold';
     var bonus_sum = 1;

   }
          display_element.innerHTML = html;


    //display buttons
    var buttons = [];
    if (Array.isArray(trial.button_html)) {
      if (trial.button_html.length == trial.choices.length) {
        buttons = trial.button_html;
      } else {
        console.error('Error in html-button-response plugin. The length of the button_html array does not equal the length of the choices array');
      }
    } else {
      for (var i = 0; i < trial.choices.length; i++) {
        buttons.push(trial.button_html);
      }
    }
    html += '<div id="jspsych-html-button-response-hd-btngroup">';
    for (var i = 0; i < trial.choices.length; i++) {
      var str = buttons[i].replace(/%choice%/g, trial.choices[i]);
      html += '<div class="jspsych-html-button-response-hd-button" style="display: inline-block; margin:'+trial.margin_vertical+' '+trial.margin_horizontal+'" id="jspsych-html-button-response-hd-button-' + i +'" data-choice="'+i+'">'+str+'</div>';
    }
    html += '</div>';

    //show prompt if there is one
    if (trial.prompt !== null) {
      html += trial.prompt;
    }
    display_element.innerHTML = html;

    // start time
    var start_time = performance.now();

    // add event listeners to buttons
    for (var i = 0; i < trial.choices.length; i++) {
      display_element.querySelector('#jspsych-html-button-response-hd-button-' + i).addEventListener('click', function(e){
        var choice = e.currentTarget.getAttribute('data-choice'); // don't use dataset for jsdom compatibility
        after_response(choice);
      });
    }




    // store response
    var response = {
      rt: null,
      button: null
    };


    // function to handle responses by the subject
    function after_response(choice) {

      // measure rt
      var end_time = performance.now();
      var rt = end_time - start_time;
      response.button = parseInt(choice);
      response.rt = rt;
//console.log('jspsych-html-button-response-hd-stimulus' + display_element.querySelector('#jspsych-html-button-response-hd-stimulus'))
      // after a valid response, the stimulus will have the CSS class 'responded'
      // which can be used to provide visual feedback that a response was recorded
      display_element.querySelector('#jspsych-html-button-response-hd-stimulus').className += ' responded';

      // disable all the buttons after a response
      var btns = document.querySelectorAll('.jspsych-html-button-response-hd-button button');
      for(var i=0; i<btns.length; i++){
        //btns[i].removeEventListener('click');
        btns[i].setAttribute('disabled', 'disabled');
      }

      if (trial.response_ends_trial) {
        end_trial();
      }
    };

    // function to end trial when it is time
    function end_trial() {

      // kill any remaining setTimeout handlers
      jsPsych.pluginAPI.clearAllTimeouts();

      if (trial.choices[response.button] == 'YES'){
        var latent_guess = 1;
      }  else {
          var latent_guess = 0;
        }

      // gather the data to store for the trial
      var trial_data = {
        rt: response.rt,
        stimulus: trial.stimulus,
        response: response.button,
        mine_weight_left: mine_weight_left[0],
        mine_weight_right: mine_weight_right[0],
        trial_weight_left: input_weight[0],
        trial_weight_right: input_weight[1],
        feedback: final_feedback,
        feedback_image: trial_valence_string,
        latent_intervention: trial.latent_intervention,
        latent_guess: latent_guess,
        latent_guess_text: trial.choices[response.button],
        mine_choice: prev_choice,
        bonus_sum: bonus_sum,

      };

      // clear the display
      display_element.innerHTML = '';

      // move on to the next trial
      jsPsych.finishTrial(trial_data);
    };

    // hide image if timing is set
    if (trial.stimulus_duration !== null) {
      jsPsych.pluginAPI.setTimeout(function() {
        display_element.querySelector('#jspsych-html-button-response-hd-stimulus').style.visibility = 'hidden';
      }, trial.stimulus_duration);
    }

    // end trial if time limit is set
    if (trial.trial_duration !== null) {
      jsPsych.pluginAPI.setTimeout(function() {
        end_trial();
      }, trial.trial_duration);
    }

  };

  return plugin;
})();
