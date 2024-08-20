import{_ as s,c as a,o as e,a7 as n}from"./chunks/framework.syuh99en.js";const k=JSON.parse('{"title":"Getting started","description":"","frontmatter":{},"headers":[],"relativePath":"getting-started.md","filePath":"getting-started.md","lastUpdated":null}'),t={name:"getting-started.md"},i=n(`<h1 id="Getting-started" tabindex="-1">Getting started <a class="header-anchor" href="#Getting-started" aria-label="Permalink to &quot;Getting started {#Getting-started}&quot;">​</a></h1><p>After successful <a href="/PersonParameters.jl/previews/PR27/index#installation">installation</a> you are ready to estimate person parameters. In this simple example we will estimate person parameters for a simulated data set assuming a <a href="https://en.wikipedia.org/wiki/Rasch_model" target="_blank" rel="noreferrer">Rasch model</a>.</p><h2 id="Simulating-data" tabindex="-1">Simulating data <a class="header-anchor" href="#Simulating-data" aria-label="Permalink to &quot;Simulating data {#Simulating-data}&quot;">​</a></h2><p>First, we need to aquire item parameters. In a Rasch model there is only a single item parameter, the <em>item difficulty</em> (<code>b</code>). Assuming a test with 10 items we therefore need 10 item difficulty parameters. For this example we draw these from a standard normal distribution.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">difficulties </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> randn</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">10</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>10-element Vector{Float64}:</span></span>
<span class="line"><span>  0.2070274100427335</span></span>
<span class="line"><span> -1.3495092955517782</span></span>
<span class="line"><span>  0.022876281016123736</span></span>
<span class="line"><span>  0.06820643528751771</span></span>
<span class="line"><span>  0.5073407408905375</span></span>
<span class="line"><span> -2.354306798176261</span></span>
<span class="line"><span>  0.07357787055165707</span></span>
<span class="line"><span> -0.7136483671007505</span></span>
<span class="line"><span> -0.5915522514911808</span></span>
<span class="line"><span>  0.5450854356895759</span></span></code></pre></div><p>Next, responses need to be simulated. Assuming 20 test-takers we simply randomly generate a response matrix where each test-taker responds to each item.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">responses </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> rand</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">20</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">10</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0.5</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>20×10 BitMatrix:</span></span>
<span class="line"><span> 1  1  0  1  1  1  1  1  1  0</span></span>
<span class="line"><span> 1  0  0  1  1  1  1  1  1  0</span></span>
<span class="line"><span> 1  1  1  1  1  0  1  0  0  1</span></span>
<span class="line"><span> 0  1  1  1  0  1  1  0  0  0</span></span>
<span class="line"><span> 1  0  1  0  0  0  1  0  0  1</span></span>
<span class="line"><span> 1  0  1  1  1  0  1  1  1  1</span></span>
<span class="line"><span> 0  0  0  1  1  0  0  1  0  1</span></span>
<span class="line"><span> 1  0  0  1  1  1  0  0  1  1</span></span>
<span class="line"><span> 0  1  1  0  1  1  1  0  1  0</span></span>
<span class="line"><span> 1  0  0  1  1  1  1  0  1  1</span></span>
<span class="line"><span> 1  1  0  1  1  0  0  1  0  1</span></span>
<span class="line"><span> 0  0  1  0  1  1  1  0  0  0</span></span>
<span class="line"><span> 1  1  0  1  0  0  0  1  0  0</span></span>
<span class="line"><span> 1  0  1  0  1  0  1  0  1  1</span></span>
<span class="line"><span> 1  1  1  1  1  1  1  1  0  1</span></span>
<span class="line"><span> 0  0  0  0  1  1  0  0  1  0</span></span>
<span class="line"><span> 0  1  0  1  0  0  1  1  0  1</span></span>
<span class="line"><span> 1  1  1  1  0  1  1  0  0  0</span></span>
<span class="line"><span> 0  1  0  0  0  1  0  0  1  1</span></span>
<span class="line"><span> 0  0  0  0  1  1  0  1  1  0</span></span></code></pre></div><h2 id="Estimation-of-person-parameters" tabindex="-1">Estimation of person parameters <a class="header-anchor" href="#Estimation-of-person-parameters" aria-label="Permalink to &quot;Estimation of person parameters {#Estimation-of-person-parameters}&quot;">​</a></h2><p>Given the item parameters <code>difficulties</code> and response matrix <code>responses</code>, we are ready to estimate person parameters. To do this only a single call to <a href="/PersonParameters.jl/previews/PR27/api#PersonParameters.person_parameters-Tuple{Type{&lt;:AbstractItemResponseModels.ItemResponseModel}, AbstractVector, Any, PersonParameterAlgorithm}"><code>person_parameters</code></a> is required. <a href="/PersonParameters.jl/previews/PR27/api#PersonParameters.person_parameters-Tuple{Type{&lt;:AbstractItemResponseModels.ItemResponseModel}, AbstractVector, Any, PersonParameterAlgorithm}"><code>person_parameters</code></a> accepts 4 arguments: the model type <code>M</code>, some <code>responses</code>, item parameters <code>betas</code> and an estimation algorithm <code>alg</code>. For this example we chose simple maximum likelihood estimation using the <a href="/PersonParameters.jl/previews/PR27/api#PersonParameters.MLE"><code>MLE</code></a> algorithm<sup class="footnote-ref"><a href="#fn1" id="fnref1">[1]</a></sup>.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> PersonParameters</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">pp </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> person_parameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(OnePL, responses, difficulties, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MLE</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">())</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>20-element PersonParameterResult{OneParameterLogisticModel, PersonParameter{Float64}, MLE}:</span></span>
<span class="line"><span> PersonParameter{Float64}(1.2275086240800022, 0.8161496019666113)</span></span>
<span class="line"><span> PersonParameter{Float64}(0.6447481694790328, 0.7230694476168512)</span></span>
<span class="line"><span> PersonParameter{Float64}(0.6447481694790328, 0.7230694476168512)</span></span>
<span class="line"><span> PersonParameter{Float64}(-0.3105668582230746, 0.6802622090510412)</span></span>
<span class="line"><span> PersonParameter{Float64}(-0.7845047981542154, 0.7010217729937231)</span></span>
<span class="line"><span> PersonParameter{Float64}(1.2275086240800024, 0.8161496019666115)</span></span>
<span class="line"><span> PersonParameter{Float64}(-0.7845047981542155, 0.7010217729937231)</span></span>
<span class="line"><span> PersonParameter{Float64}(0.15290728124212366, 0.6858082672443989)</span></span>
<span class="line"><span> PersonParameter{Float64}(0.1529072812421236, 0.6858082672443989)</span></span>
<span class="line"><span> PersonParameter{Float64}(0.6447481694790326, 0.7230694476168512)</span></span>
<span class="line"><span> PersonParameter{Float64}(0.15290728124212363, 0.6858082672443989)</span></span>
<span class="line"><span> PersonParameter{Float64}(-0.7845047981542154, 0.7010217729937231)</span></span>
<span class="line"><span> PersonParameter{Float64}(-0.7845047981542156, 0.7010217729937231)</span></span>
<span class="line"><span> PersonParameter{Float64}(0.15290728124212344, 0.6858082672443989)</span></span>
<span class="line"><span> PersonParameter{Float64}(2.077240228324489, 1.0713408728475078)</span></span>
<span class="line"><span> PersonParameter{Float64}(-1.308761233731677, 0.7530390076178167)</span></span>
<span class="line"><span> PersonParameter{Float64}(-0.3105668582230747, 0.6802622090510412)</span></span>
<span class="line"><span> PersonParameter{Float64}(0.1529072812421236, 0.6858082672443989)</span></span>
<span class="line"><span> PersonParameter{Float64}(-0.7845047981542155, 0.7010217729937231)</span></span>
<span class="line"><span> PersonParameter{Float64}(-0.7845047981542157, 0.701021772993723)</span></span></code></pre></div><p>The resulting <a href="/PersonParameters.jl/previews/PR27/api#PersonParameters.PersonParameterResult"><code>PersonParameterResult</code></a> object contains the estimated person parameters for all 20 test-takers. The estimate of a single person can be obtained by indexing the <code>pp</code> object.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">pp17 </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> pp[</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">17</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">]</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>PersonParameter{Float64}(-0.3105668582230747, 0.6802622090510412)</span></span></code></pre></div><p>The <a href="/PersonParameters.jl/previews/PR27/api#PersonParameters.PersonParameter"><code>PersonParameter</code></a> object consists of the estimate and standard error of estimation for a single test-taker. To access the values you can use <a href="/PersonParameters.jl/previews/PR27/api#PersonParameters.value-Tuple{PersonParameter}"><code>value</code></a> and <a href="/PersonParameters.jl/previews/PR27/api#PersonParameters.se-Tuple{PersonParameterAlgorithm, Type{&lt;:AbstractItemResponseModels.ItemResponseModel}, Any, Any}"><code>se</code></a> respectivelty.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">value</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(pp17)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>-0.3105668582230747</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">se</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(pp17)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>0.6802622090510412</span></span></code></pre></div><h2 id="How-to-continue-from-here?" tabindex="-1">How to continue from here? <a class="header-anchor" href="#How-to-continue-from-here?" aria-label="Permalink to &quot;How to continue from here? {#How-to-continue-from-here?}&quot;">​</a></h2><p>For specific use cases see one of our guides:</p><ul><li><a href="/PersonParameters.jl/previews/PR27/guides/adaptive-testing">Online estimation of ability in adaptive testing</a></li></ul><p>Or you can dive straight into the <a href="/PersonParameters.jl/previews/PR27/api">API Reference</a>.</p><hr class="footnotes-sep"><section class="footnotes"><ol class="footnotes-list"><li id="fn1" class="footnote-item"><p>For a full list of implemented algorithms see the <a href="/PersonParameters.jl/previews/PR27/api#types">API Reference</a>. <a href="#fnref1" class="footnote-backref">↩︎</a></p></li></ol></section>`,27),p=[i];function l(r,o,c,d,h,m){return e(),a("div",null,p)}const u=s(t,[["render",l]]);export{k as __pageData,u as default};
