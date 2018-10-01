

jsPsych.plugins["feedback-rand-1"] = (function() {

  var plugin = {};

  plugin.trial = function(display_element, trial) {

    // default trial parameters
    trial.button_html = trial.button_html || '<button class="jspsych-btn">%choice%</button>';
    trial.response_ends_trial = (typeof trial.response_ends_trial === 'undefined') ? true : trial.response_ends_trial;
    trial.timing_stim = trial.timing_stim || -1; // if -1, then show indefinitely
    trial.timing_response = trial.timing_response || -1; // if -1, then wait for response forever
    trial.is_html = (typeof trial.is_html === 'undefined') ? false : trial.is_html;
    trial.prompt = (typeof trial.prompt === 'undefined') ? "" : trial.prompt;
    trial.block_id = trial.block_id;
    trial.latent_intervention = trial.latent_intervention; //added
    trial.feedback_image = trial.feedback_image; //added
    trial.agent_image = trial.agent_image; //added

    // if any trial variables are functions
    // this evaluates the function and replaces
    // it with the output of the function
    trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);

    // this array holds handlers from setTimeout calls
    // that need to be cleared if the trial ends early
    var setTimeoutHandlers = [];
    // function to determine latent agent intervention or not (picks either the agent weights (1,0) or mine weights (x,1-x))

              function getWeightBen (intermediate){
                if (intermediate == [1]){ //pick the latent agent weights - for benev agent it is [1,0]
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

                  var final_weight = getWeightBen(feedback_prob_post) //final weight decision




                    if (trial.block_id == 'benevolent'){
                      conditionText = 'Tycoon Territory';
                    } else if (trial.block_id == 'adversarial') {
                      conditionText = 'Bandit Territory';
                    } else if (trial.block_id == 'random') {
                      conditionText = 'Sheriff Territory';
                    }


                    //display room text
                    var roomText = conditionText
                         display_element.append($('<div>', {
                           "id": 'roomText1',
                           "class": 'jspsych-room-text',
                         }));

                         $('#roomText1').text(conditionText)


                     // //display latent agent condition pic
                     var agentPic = roomText
                          display_element.append($('<img>', {
                            "src": trial.agent_image,
                            "id": 'jspsych-sim-stim',
                            class: 'agent-design'
                          }));


                var prev_choice_temp = jsPsych.data.getTrialsOfType('two-initial-choice')

                var t_index = prev_choice_temp.length-1
                var prev_choice = prev_choice_temp[t_index].button_pressed


                if (prev_choice == 0){
                  var side = "left"
                  if (!trial.is_html) {
                    display_element.append($('<img>', {
                      "src": trial.stimuli[0],
                      //"id": 'jspsych-sim-stim',
                      class: 'jspsych-xab-stimulus left'
                    }));
                    display_element.append($('<img>', {
                      "src": outcome_blank,
                      //"id": 'jspsych-sim-stim',
                      class: 'jspsych-xab-stimulus right'
                    }));
                  } else {
                    display_element.append($('<div>', {
                      "html": trial.stimuli[0],
                      //"id": 'jspsych-sim-stim',
                      class: 'jspsych-xab-stimulus left'
                    }));
                    display_element.append($('<div>', {
                      "html": outcome_blank,
                      //"id": 'jspsych-sim-stim',
                      class: 'jspsych-xab-stimulus right'
                    }));
                  }
                  } else {
                    side = "right"
                    if (!trial.is_html) {
                      display_element.append($('<img>', {
                        "src": outcome_blank,
                        //"id": 'jspsych-sim-stim',
                        class: 'jspsych-xab-stimulus left'
                      }));
                      display_element.append($('<img>', {
                        "src": trial.stimuli[1],
                        //"id": 'jspsych-sim-stim',
                        class: 'jspsych-xab-stimulus right'
                      }));
                    } else {
                      display_element.append($('<div>', {
                        "html": outcome_blank,
                        //"id": 'jspsych-sim-stim',
                        class: 'jspsych-xab-stimulus left'
                      }));
                      display_element.append($('<div>', {
                        "html": trial.stimuli[1],
                        //"id": 'jspsych-sim-stim',
                        class: 'jspsych-xab-stimulus right'
                      }));
                    }
                  }


                  if (prev_choice == 0) { // if they chose the L mine
                    input_weight = final_weight[0]; //use left side mine prob
                  } else {
                    input_weight = final_weight[1]; //use right side mine prob
                  }



                  var final_feedback = getRandom(input_weight) //get final feedback decision

            



                  // display feedback
                  if (side == 'left' && final_feedback == 1){ //win and left
                    var stimulus_shown = 'win'
                    display_element.append($('<img>', {
                      "src": trial.feedback_image[1],
                      "id": 'jspsych-sim-stim',
                      //class: 'feedback-design'
                      class: 'inner left_fb'
                      //class: 'jspsych-xab-stimulus left'
                    }));
                  } else if (side == 'right' && final_feedback == 1) { //win and right
                    var stimulus_shown = 'win'
                    display_element.append($('<img>', {
                      "src": trial.feedback_image[1],
                      "id": 'jspsych-sim-stim',
                      //class: 'feedback-design'
                      class: 'inner right_fb'
                      //class: 'jspsych-xab-stimulus right'
                    }));
                  } else if (side == 'left' && final_feedback == 0) { //loss and left
                    var stimulus_shown = 'loss'
                    display_element.append($('<img>', {
                      "src": trial.feedback_image[0],
                      "id": 'jspsych-sim-stim',
                      //class: 'feedback-design'
                      class: 'inner left_fb'
                      //class: 'jspsych-xab-stimulus left'
                    }));
                  } else if (side == 'right' && final_feedback == 0) { //loss and right
                    var stimulus_shown = 'loss'
                    display_element.append($('<img>', {
                      "src": trial.feedback_image[0],
                      "id": 'jspsych-sim-stim',
                      //class: 'feedback-design'
                      class: 'inner right_fb'
                      //class: 'jspsych-xab-stimulus right'
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
              display_element.append('<div id="jspsych-button-response-btngroup" class="center-content block-center"></div>')
              for (var i = 0; i < trial.choices.length; i++) {
                var str = buttons[i].replace(/%choice%/g, trial.choices[i]);
                $('#jspsych-button-response-btngroup').append(
                  $(str).attr('id', 'jspsych-button-response-button-' + i).data('choice', i).addClass('jspsych-button-response-button').on('click', function(e) {
                    var choice = $('#' + this.id).data('choice');
                    after_response(choice);
                  })
                );
              }

              //show prompt if there is one
              if (trial.prompt !== "") {
                display_element.append(trial.prompt);
              }

              // store response
              var response = {
                rt: -1,
                button: -1
              };

              // start time
              var start_time = 0;

              // function to handle responses by the subject
              function after_response(choice) {

                // measure rt
                var end_time = Date.now();
                var rt = end_time - start_time;
                response.button = choice;
                response.rt = rt;

                // after a valid response, the stimulus will have the CSS class 'responded'
                // which can be used to provide visual feedback that a response was recorded
                $("#jspsych-button-response-stimulus").addClass('responded');

                // disable all the buttons after a response
                $('.jspsych-button-response-button').off('click').attr('disabled', 'disabled');

                if (trial.response_ends_trial) {
                  end_trial();
                }
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
                  "stimulus": trial.stimuli,
                  "button_pressed": response.button,
                  "block_id": trial.block_id,
                  "mine_prob_win_left": i_weight,  //probability of win for L mine in this block
                  "mine_prob_win_right": j_weight,  //probability of win for L mine in this block
                  "gamble_feedback": final_feedback, //feedback for the gamble (0 for loss, 1 for win)
                  "latent_agent": trial.latent_intervention, //did latent agent intervene?
                  "weights": input_weight, //weights used for feedback
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
              if (trial.timing_response > 0) {
                var t2 = setTimeout(function() {
                  end_trial();
                }, trial.timing_response);
                setTimeoutHandlers.push(t2);
              }

            };

            return plugin;
          })();
