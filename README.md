<h1 align="center">BUET Bus Entrance System using Voice Recognition</h1>
<h4 align="justify">This project represents a text dependent voice  recognition based digital system for BUET Bus Service over the  existing conventional system to help the students. . To design, the 
software part of our proposed system, MFCC is used for extracting feature of the given voice. In this algorithm, the cepstral co-efficient are calculated at Mel frequency scale.
vector quantization and Euclidean distance methods are used for feature matching through MATLAB. Here, the pattern of a student’s voice will be compared with the patterns stored in the 
student database in training session of the system. The quality and testing of this speaker recognition system is completed and analyzed, and we have found that when we use strong noise 
cancelling devices for voice input, the accuracy of the system is very satisfactory.</h4>


## METHODOLOGY
## A. Voiced/ unvoiced/ silence detection and silence removal:
<h4 align="justify">Voiced parts of a speech are almost periodic and have 
more correlation among successive samples. These contain 
more useful information and higher energy than the silence 
and unvoiced portion. Moreover, silence/unvoiced portion of 
speech is affected more by noise than voiced portion. So, 
removal of this redundant information through proper 
segmentation does not only ensure the reduction of number of 
computation but also increases the accuracy of speech 
processing. At first, the data was sampled at 44100 
samples/sec. Frame size was considered as Fs/100. Using first 
(44100/5) =8820 samples, the parameters µ and σ were 
calculated because the first 8820 samples of the input speech 
contain background noise/ white noise and so its distribution 
is normal distribution. Then, for any sample x if (x-µ)/ σ > the 
adjusted threshold, then we consider that it belongs to the 
distribution of background noise and hence it can be 
eliminated from the speech part. Thus, the number of voiced 
samples and unvoiced samples of each frame was counted. 
Based on this, we divided the frames as voiced frames and 
unvoiced frames. Our silence removed signal was formed by 
including the voiced frames only.</h4>


## B. Framing
<h4 align="justify">We split signal up into (overlapping) frames: one per row
and keep the samples of each frame along their respective row. 
We chose hamming windowing. By default, the number of 
frames will be rounded down to the nearest integer and the last 
few samples of x() will be ignored unless its length is lw more 
than a multiple of inc where w is the frame size and inc is 
frame increase in samples. If the 'z' or 'r' options are given, the 
number of frames will instead be rounded up and zero padding 
is done or last few samples were reflected for final frame. Depending on the number of samples, total number of frames 
can be varied. At first, frame size was 100ms, but after 
hamming windowing with length 20ms window for improving 
efficiency, frame size changed into 20ms.
</h4>

## C. Calculating Discrete Fourier Transform (DFT)
<h4 align="justify">After performing framing and windowing, it was required 
to calculate DFT for each point of each frame in order to get 
a frequency spectrum of the pre-processed speech and also to 
understand better what frequencies it is composed of, so that 
we can do further processing of it. For fast computation, we 
used the build in function fft of MATLAB to find DFT.
Before performing the DFT, if the frame duration was not 
mentioned, then it was required to convert the speech length 
to 2’s power, because 2’s power point DFT helps to make the 
computation and understanding easier. It was done by 
rounding the number of samples to its nearest smallest 2’s 
power value. 
For human speech, most of the information lies within 4kHz.</h4>

## D. Calculating Power Spectrum
<h4 align="justify">Analyzing the speech in frequency domain is easier than 
in time domain because we can measure the power contained 
in each frame just by taking the square of the absolute value 
of DFT of each point and then measuring their average. This 
is compared to the human cochlea, which vibrates at different 
spots depending on the frequency values, and based on its 
location of vibration, nerves send the signal to inform the 
amount of any frequency component present.
</h4>

## E. Mel Filter Bank
<h4 align="justify">
Human ears perceive frequency logarithmically, whereas 
machines perceive the sound linearly. Human ears have 
higher resolution at low frequencies, but machines treat all 
ranges of frequencies in a similar way. So, modeling the 
human hearing property at the feature extraction stage will 
improve the performance of the model.The formula for 
mapping the actual frequency to the frequency that human 
beings will perceive is given below:</br>
mel(f)=1127*ln (1+ 𝑓/700)</br>
At first, lowest and highest frequencies were converted to 
MEL units and then divided into 32 filter banks having 
equally spaced points. After that, these points were converted 
back to Hertz following the inverse mel equation and rounded 
to the nearest frequency bins so that spectral leakage did not happen. It is not possible to provide infinite resolution in 
frequency domain. To estimate the amount of energy present in various
frequency ranges, we take groups of periodogram bins and 
add them together. The Mel filter bank does this; the first 
filter is extremely narrow and indicates how much energy is 
close to 0 Hertz. As the frequencies increase, the filters get 
wider to have the same perceptual difference in terms of 
frequency distances.
</h4>

## F. Discrete Cosine Transform(DCT)
<h4 align="justify">DCT expresses a finite sequence of data points in terms of a 
sum of cosine functions oscillating at different frequencies. 
DCT is inverse Fourier transform with reduced computation 
because it deals with real numbers only. Our filter banks were 
all overlapping. The filter bank energies were quite correlated 
with each other. The DCT decorrelated the energies in 
different Mel bands. But only 15 of the 32 DCT coefficients 
are kept. This is because the higher DCT coefficients 
represent fast changes in the filter bank energies, and these 
fast changes degrade the performance of speech processing, 
so we get a slight improvement by dropping them.</h4>

## G. Delta and delta-delta co-efficients:
<h4 align="justify">Although the MFCC feature vector only captures the power 
spectral envelope of a single frame, speech would also 
contain information about dynamics, or more specifically, 
about the trajectories of the MFCC coefficients over time. It 
turns out that adding the MFCC trajectories to the original 
feature vector after computing them significantly improves 
the performance of speech processing. We had 15 MFCC 
coefficients, we would also get 15 delta coefficients and 15 
delta-delta coefficients. A feature vector of length 45 would 
result from the combination. As we performed hamming 
windowing, we skipped these two steps. But our project code 
includes it and so this part of code can also be executed by 
changing the window type.
</h4>

## H. Vector Quantization
<h4 align="justify">The technique of mapping vectors from a huge vector 
space to a limited number of regions in that space is known 
as vector quantization. Each area is referred to as a cluster 
and can be depicted by its center called a centroid [2,4]. The 
VQ encoder encodes a given set of k-dimensional data 
vectors with a much smaller subset. The subset is called a 
codebook and its elements Ci are called codewords, code 
vectors, reproducing vectors, prototypes, or design samples. 
Only the index i is transmitted to the decoder. The decoder 
has the same codebook as the encoder, and decoding is 
operated by table look-up procedure. The commonly used 
vector quantizers are based on nearest neighbor called 
Voronoi or nearest neighbor vector quantizer. Both the 
classical K-means algorithm and the LBG algorithm belong 
to the class of nearest neighbor quantizers.
A key component of pattern matching is the measurement of 
dissimilarity between two feature vectors. The measurement 
of dissimilarity satisfies three metric properties such as 
Positive definiteness property, Symmetry property and 
Triangular inequality property. Each metric has three main 
characteristics such as computational complexity, analytical 
tractability and feature evaluation reliability. The metrics 
used in speech processing are derived from the Minkowski 
metric.The performance of the vector quantizer can be evaluated by 
a distortion measure D which is a non-negative cost D (X j, 
X j) associated with quantizing any input vector X j with a 
reproduction vector X j. Usually, the Euclidean distortion 
measure is used. The performance of a quantizer is always 
qualified by an average distortion Dy = E [D (X j Xj)] 
between the input vectors and the final reproduction vectors, 
where E represents the expectation operator. Normally, the 
performance of the quantizer will be good if the average 
distortion is small.</h4>

## I. Euclidean Distance Measurement
<h4 align="justify">The voice of an unknown speaker is represented by a series 
of feature vectors (x1, x2,....xi) during the speaker 
recognition phase, and it is then compared to codebooks from 
the database. Based on reducing the Euclidean distance, it is 
possible to determine the speaker's identity by calculating the 
distortion distance between two vector sets. The speaker with the lowest distortion distance is chosen to 
be identified as the unknown person.</h4>

To know more : https://github.com/theRaihann/BUET-Bus-Entrance-System-using-Voice-Recognition/blob/main/PAPER.pdf

