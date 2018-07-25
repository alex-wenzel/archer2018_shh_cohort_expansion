# Make predictive model using Cho et al. and predict the subtypes of 20 PDX samples
options(echo=FALSE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
train_data_file <- args[1]
train_labels_file <- args[2]
model_dir <- args[3]
test_data_file <- args[4]
out_dir <- args[5]
run_training <- args[6]

dir.create(model_dir, showWarnings = FALSE)
dir.create(out_dir, showWarnings = FALSE)

train_plots_file <- paste(model_dir, '/train_plots.pdf', sep='')
ev_file <- paste(model_dir, '/train_ev.txt', sep='')
model_file <- paste(model_dir, '/train.MODEL.Rdata', sep='')
train_output_gct <- paste(model_dir, '/train_output.gct', sep='')
train_output_txt <- paste(model_dir, '/train_output.txt', sep='')

print(out_dir)
test_plots_file <- paste(out_dir, '/test_plots.pdf', sep='')
test_output_gct <- paste(out_dir, '/test_output.gct', sep='')
test_output_txt <- paste(out_dir, '/test_output.txt', sep='')

source("../scripts/CCBA_library.v1.2.R")

print('LOADED LIBRARY')
train_data = CCBA_read_GCT_file.v1(train_data_file)
if (run_training){
  CCBA_train_Bayesian_predictor(
    target.dataset           = train_labels_file,
    target                   = "subtypes",
    target_type              = "categorical",         # Type of target: "categorical" or "numeric"
    features.dataset         = train_data_file,
    features                 = train_data$row.names,
    output.plots             = train_plots_file,
    plot.nomograms           = T,
    ev.file                  = ev_file,
    discretize.target        = F,
    model.file               = model_file,
    output.dataset.gct       = train_output_gct,
    output.dataset.txt       = train_output_txt);
}

print('TRAINING FINISHED.')

CCBA_apply_Bayesian_predictor(
  target.dataset       = NULL,
  features.dataset     = test_data_file,
  model.file           = model_file,
  plot.nomograms       = T,
  output.plots         = test_plots_file,
  output.dataset.gct   = test_output_gct,
  output.dataset.txt   = test_output_txt);

print('TESTING FINISHED.')
