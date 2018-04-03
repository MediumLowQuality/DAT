scriptname MLQ_NormalDistribution

float floatMin = -170141183460469000000000000000000000000.00 ; these are just for reference; numbers are magic numbers in the code since Papyrus can't into static variables
float floatMax = 170141183460469000000000000000000000000.00
float root2 = 1.414213562
float e = 2.71828182845904523536

float function inverf(float z) global
{Returns the inverse of the erf function, defined for real numbers on the range [-1, 1]}
	; constants for the inverse erf function, based on the MacLaurin expansion; hopefully this saves on some math time
	float[] c = new float[17]
	c[0]  = 0.886226925452758
	c[1]  = 0.232013666534655
	c[2]  = 0.127556175305598
	c[3]  = 0.0865521292415475
	c[4]  = 0.0649596177453854
	c[5]  = 0.0517312819846164
	c[6]  = 0.0428367206517973
	c[7]  = 0.0364659293085316
	c[8]  = 0.0316890050216055
	c[9]  = 0.0279806329649952
	c[10] = 0.0250222758411982
	c[11] = 0.0226098633188977
	c[12] = 0.0206067803790589
	c[13] = 0.0189182172507789
	c[14] = 0.0174763705628565
	c[15] = 0.0162315009876852
	c[16] = 0.0151463150632478
	float sum = 0.0
	int i = 0
	while i < 17
		sum += c[i]*z ; add z*constant to sum
		z *= z*z ; increase exponent by 2 after every iteration, such that z in each iteration is z0^(2k+1)
		i += 1
	endWhile
	return sum
endFunction

float function random(float mean = 0.0, float stdDev = 1.0, bool usingClamps = false, float lowerClamp = -170141183460469000000000000000000000000.0, float upperClamp = 170141183460469000000000000000000000000.0) global
{returns a random number, distributed according to a normal distribution with mean mean and standard deviation stdDev; if usingClamps is true, clamps the returned value between upperClamp and lowerClamp}
	float rand = Utility.randomFloat(-1.0, 1.0) ; magic number below is root 2
	float x = inverf(rand)*stdDev*1.414213562 + mean ; CDF function for normal distribution is p(x) = 1/2(1 + erf[(x - mu)/(sigma*root2)]). Putting randomFloat in [-1,1] instead of [0,1] handles *2 and - 1, expression is then solved for x
	if(usingClamps && (x < lowerClamp || x > upperClamp)) ; we're doing this instead of box mueller because if I'm implementing an ln function I'm doing it fucking right
		if (x < lowerClamp)
			x = lowerClamp
		elseif (x > upperClamp)
			x = upperClamp
		endIf
	endIf
	return x
endFunction

float function evaluateLowerClampPool(float mean = 0.0, float stdDev = 1.0, float lowerClamp = -170141183460469000000000000000000000000.0) global
{evaluates the likelihood of the function random returning a value <= lowerClamp with the provided parameters; this is not optimized for speed}
	float x = (lowerClamp - mean)/(stdDev*1.414213562)
	float t = 1/(1 + 0.5*Math.abs(x))
	float exp = -Math.pow(x, 2.0) - 1.26551223 + 1.00002368*t + 0.37409196*Math.pow(t, 2.0) + 0.09678418*Math.pow(t, 3.0) - 0.18628806*Math.pow(t, 4.0) + 0.27886807*Math.pow(t, 5.0) - 1.13520398*Math.pow(t, 6.0) + 1.48851587*Math.pow(t, 7.0) - 0.82215223*Math.pow(t, 8.0) + 0.17087277*Math.pow(t, 9.0)
	float tau = t*Math.pow(2.71828182845904523536, exp) ; magic number here is e
	float erf = 1.0 - tau
	if (x < 0)
		erf *= -1.0
	endIf
	float prob = 0.5*(1 + erf)
	return prob
endFunction

float function evaluateUpperClampPool(float mean = 0.0, float stdDev = 1.0, float upperClamp = 170141183460469000000000000000000000000.0) global
{evaluates the likelihood of the function random returning a value >= upperClamp with the provided parameters; this is not optimized for speed}
	float x = (upperClamp - mean)/(stdDev*1.414213562) ; root 2 again
	float t = 1/(1 + 0.5*Math.abs(x))
	float exp = -Math.pow(x, 2.0) - 1.26551223 + 1.00002368*t + 0.37409196*Math.pow(t, 2.0) + 0.09678418*Math.pow(t, 3.0) - 0.18628806*Math.pow(t, 4.0) + 0.27886807*Math.pow(t, 5.0) - 1.13520398*Math.pow(t, 6.0) + 1.48851587*Math.pow(t, 7.0) - 0.82215223*Math.pow(t, 8.0) + 0.17087277*Math.pow(t, 9.0)
	float tau = t*Math.pow(2.71828182845904523536, exp) ; magic number here is e
	float erf = 1.0 - tau
	if (x < 0)
		erf *= -1.0
	endIf
	float prob = 1 - 0.5*(1 + erf)
	return prob
endFunction