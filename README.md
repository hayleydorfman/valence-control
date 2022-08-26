**Data, code, and tasks for Dorfman, et al., 2019, Psych Science**

Citation for use of any code, data, or task: Dorfman, H. M., Bhui, R., Hughes, B. L., & Gershman, S. J. (2019). Causal Inference About Good and Bad Outcomes. Psychological Science, 133, 956797619828724. http://doi.org/10.1177/0956797619828724

All materials found here can also be found on the first author’s GitHub: https://github.com/hayleydorfman/valence-control).

Modeling code, some analysis code, and plotting functions were developed by Sam Gershman. Updates and tutorials for modeling code can be found at his GitHub: https://github.com/sjgershm/mfit.

**Tasks**

The behavioral tasks used for both experiments in the paper are provided here. They were written using Josh deLeeuw's jsPsych toolbox (http://www.jspsych.org/).

Both tasks will not run "out of the box" because they require communication with a PHP server. You can achieve this by running them on your own domain, or by using a tool like XAMPP to run the PHP server locally. You could also use an easy-to-use experiment hosting service - my favorite of which is Cognition (https://www.cognition.run/).

Please also note that slight modifications may need to be made to the existing code to either run the task locally or on a hosting service. For example, the consent and data save functions will need to be commented out in order to run the task locally (if you do not have PHP capabilities). For more information on running online jsPsych experiments, please see the extensive documentation available on the jsPsych website, Github discussion forum, and particularly here (https://www.jspsych.org/overview/running-experiments/).

IMPORTANT NOTE: The version of the experiments used in the original study are coded in jsPsych version 5.0.3. This version is not compatible with cognition.run and may not be compatible with other hosting services. I have updated the task code (located on my GitHub here: https://github.com/hayleydorfman/valence-control/tree/master/experiment_task_jspsych631) using jsPsych v.6.3.1, which is compatible with Cognition. This version of the experiment is still undergoing testing and has not been used in a published study. In particular, you may need to edit the CSS to be compatible with different screen sizes/operating systems. If you find any bugs, please feel free to contact me.

**Data**

The data for all of the participants included in both experiments are provided here. The variable names can be found in the headers of these csv files, and a key is provided below.

‘exp1_data.csv’ and ‘exp2_data.csv’ are located in the ‘model’ folder and have been formatted specifically for model fitting.

‘exp1_behav_data.csv’ and ‘exp2_behav_data.csv’ include additional variables, including the learning rates from the winning models.


**Variable Key**

**feedback**: reward feedback received (0 = negative outcome, 1 = positive outcome)

**latent_agent**: did the latent agent intervene on this trial? (0 = no, 1 = yes)

**subject**: unique, non-identifiable subject ID number

**latent_prob**: probability of latent agent intervention for this version of the task

**mine_prob_win_left**: probability of a positive outcome for the stimulus on the left side

**mine_prob_win_right**: probability of a positive outcome for the stimulus on the right side

**latent_guess**: button press for subject guess about latent agent intervention (0 = no, agent did not intervene, 1 = yes, agent did intervene)

**block_num**: block order

**trial_num**: trial number

**condition**: condition (1 = adversarial, 2 = benvolent, or 3 = random)

**subj_choice**: button press (1 = left, 2 = right)

**lr**: learning rates from the best-fitting model

**Model Fitting**

1.	Download or copy the entire ‘model’ folder and the csv data files to your local computer. There may be MATLAB dependencies/functions necessary to run the models that you may need to download separately. This includes the MATLAB Optimization Toolbox (https://www.mathworks.com/products/optimization.html) and the Statistics and Machine Learning Toolbox (https://www.mathworks.com/products/statistics.html). 
2.	Open ‘model’ folder in MATLAB (version 2019b or later preferred)
3.	Make sure a copy of the data csv file you want to fit models to is located in the ‘model’ folder/in the location on your computer where you are running models.
4.	Type the following in the MATLAB command window:

**data = load_data("mydataframename.csv")** [hit return/enter] 
(NOTE: If you are using the data from our 2019 paper, this filename would be either ‘exp1_behav_data.csv’ or ‘exp2_behav_data.csv’)

**[results, bms_results] = fit_models(1)** [hit return/enter]

**save('model_output_myfilename.mat', 'data', 'results', 'bms_results')** [hit return/enter]

The following files/lines can be modified depending on your goals:

**fit_models.m**

 - filename should be the input data of your choice (make sure this matches what you loaded into MATLAB!)
 - likfuns should be the models you want to compare
 - The number in the command ‘[results, bms_results] = fit_models(1)’ can be changed to switch which group of models you want to compare.
 - This file also includes case switching for each possible likelihood function. This is where you can call new likelihood functions for each model, including upper and lower bounds for free parameters.


**load_data.m**

 - If you neglect to input a csv filename in the “data = load_data” line above, this will automatically load a file called “exp1_behav_data.csv.”

**Any file that begins with “lik_”.m**

 - These are the model likelihood function files. You can change anything in these to suit your model.
 - If making changes, copy/paste and make a new file with a new name.

Note: If you are switching between experiments or model comparisons, always take care to type ‘clear all’ between analyses and make sure to load in the correct data files.

Note: Each time you run the model fits, your parameters values may change/vary slightly. However, your model comparison metrics/overall conclusions should remain the same. A solution to this is to save out your model results immediately (i.e., don’t continually re-run the models) and/or to set a seed.

**Saving Model Fits**

To save your model fitting results, you can type the following in your MATLAB command window:

**save('my_model_output.mat', 'results', 'data', 'bms_results')**

**Understanding Model Output**

Fitting your models will create two output files: 1) results and 2) bms_results.

***‘results’:***

This is where you will find the models you compared and their fitted parameters.  For example, ‘results(1).x’ will index all of the free parameters for the first model. ‘results(1).latents’ will index output for the dynamic parameters from the Bayesian models (if there is an applicable Bayesian model listed first).

***‘bms_results’:***

This is where you will find the model comparison values for each model (displayed in the order in which they were compared in ‘fit_models.m’).

**Plotting**

You can use the ‘plot_results.m’ file to generate plots from the paper. Please refer to the usage information at the top of the file.

**Model File Key**

***Experiment 1 Model Files:***

**lik_asym.m**: Likelihood function for the 6-learning rate model. Includes seven free parameters (inverse temperature, 6 learning rates for each condition x valence pairing)

**lik_asym_sticky.m**: Likelihood function for the 6-learning rate model. Includes eight free parameters (inverse temperature, stickiness, 6 learning rates for each condition x valence pairing)

***lik_rational.m**: Likelihood function for the “Bayesian” model used in Experiment 1. Includes two free parameters for inverse temperature and stickiness. Fixed prior probability of hidden-agent intervention at 30%

**lik_free_pz.m**: Likelihood function for a variation of the “Bayesian” model used in Experiment 1. Includes three free parameters for inverse temperature, stickiness, and hidden-agent intervention.

**lik_asym0_sticky.m:** Likelihood function for the 2-learning rate model. Includes four free parameters (inverse temperature, stickiness, 2 learning rates for each valence)

***Experiment 2 Model Files:***

**lik_asym_sticky.m**: Likelihood function for the 6-learning rate model. Includes eight free parameters (inverse temperature, stickiness, 6 learning rates for each condition x valence pairing)

***lik_rational4.m**: Likelihood function for the “Empirical Bayesian” model used in Experiment 2. Includes two free parameters for inverse temperature and stickiness. Prior probability of hidden-agent intervention uses the mean of the subjective intervention judgments.

**lik_rational_adaptive6.m**: Likelihood function for the “Adaptive Bayesian” model used in Experiment 2. Includes four free parameters for inverse temperature, stickiness, alpha, and beta (to represent bias in underlying reward distribution). “Agency” parameter is derived adaptively using Baye’s rule.

**lik_free_pz.m**: Likelihood function for a variation of the “Fixed Bayesian” model used in Experiment 1. Includes three free parameters for inverse temperature, stickiness, and hidden-agent intervention.

*Best-fitting model

**Contact**

For questions, please contact Hayley Dorfman (hdorfman@g.harvard.edu).



