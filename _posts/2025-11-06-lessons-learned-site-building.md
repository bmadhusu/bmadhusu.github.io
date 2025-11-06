---
title:  "Lessons Learned from putting up a site"
layout: post
categories: coding
---

So I actually vibe coded a site and put it into production. It wasn't a terribly sophisticated site. It was a single page application on a Typescript/React stack with no database. Really pretty simple.

But it was a passion project and I needed it up and running in a very quick timeframe. It was a lot of fun because basically everything was new to me.
I used Cursor for this development and made more use of GitHub than I ever have previously.

## Privacy with Email


I wanted to set up an email to receive feedback but did not want to use my personal email. So the AI suggested a few options, including proton mail, and SimpleLogin. I've heard of proton mail and a number of friends use it, but I never bothered. However, upon the AI suggesting it as a possible solution, I decided to enroll.

The other suggestion that was made was to obfuscate the email so that bots/scrapers wouldn't pick it up and start spamming me. I went with a "click-to-reveal" solution that was implemented in Javascript since scrapers don't do anything with Javascript.

## To save or not to save

My first inclination and how I implemented the app because I was so concerned with privacy was to not save anything and instead keep everything in the URL; this meant that I would make use of fragments: you know, the stuff that follows the # sign. Fragments are purely client side; if I were to hand you the URL, and you clicked it, the browser would load the page but never send the fragment to the server. The fragment. would be used to populate the elements in the page once it's been loaded so the server never sees what's in the fragment. 

This all sounded pretty secure to me, but what wound up happening was the fragments would get gigantic based on how much information you put into the text boxes on the form. This then became untenable when sharing because text messages and WhatsApp messages would cut the fragment off from the URL. So sharing would be broken. This was a non-starter.

So I explored a few possible solutions. The first one was to compress the fragment using the pako library. I went with this, but this itself wouldn't give me too much. I then looked at using a URL shortener: products like bit.ly and tinyurl; I looked at their free tiers but after imagining large volumes (which eventually never materialized so maybe it was a non-issue, but hey, I had grand ambitions!), I decided I didn't want to go that route.
 
There was also the matter of dealing with the API Key. I obviously couldn't expose this on the client side, so the only solution would be to make use of a server to call out to the url shortener service. But that would take me into using a back-end which I was trying to avoid.

So after quizzing my AI pal on the various approaches, I decided to abandon URL fragments and switch over to using proper query strings with a key value store on the backend. It just made more sense, rather than to deal with all this other nonsense.

## Playing with Netlify

I got to use Netlify and its generous free-tier in implementing the above, making use of blobs as key-value stores. It all worked out quite well!

If you want to see more logs, and analytics, you need to actually pay. Not something I needed right now. I was trying to do this as cheaply as possible.

## Copy / Paste

I primarily used my computer to code this, so obviously I also tested on my desktop first and foremost, but of course this SPA would be used way more on mobile. So when I tried, that's when I discovered how complex a simple operation like copy/paste can be!

When I used the Copy feature on my phone, I learned about the Clipboard API on mobile and how it sometimes doesn't work. The AI recommended using the Native Share API which doesn't have clipboard restrictions. On mobile, upon clicking Copy, this would open up the various apps to which to share to.

So I learned about the ~navigator~ browser object and that it can be utilized for all kinds of operations.

However, using this navigator sharing was adversely affecting the desktop app by bringing up the share dialog, which was just plain **weird**.

So the AI also put in a check for mobile and only then did it use the navigator type of sharing. On desktop, it reverted to using the Clipboard API.

## Cold Start Issues

This was a very interesting problem! As I was testing my app, I would use the url with a query string on another browser in incognito mode. This would return a "Failed to load resource:" 404 error. And then when I reloaded it again, the page would appear.
Weird!

The AI figured it out though. Since I was using a serverless function on a free-tier, I was not going to get priority service, thus my app would need to wait until the serverless functions were 'warm'.

I was given several options to choose from. I went with showing a loading message with a timeout so that if there was a 404, the app would retry.

## Cursor 2.0

In the middle of all of this development, cursor 2.0 dropped with full on agent mode. It was way more sophisticated and in fact when I asked it things, it would actually even spin up a browser to verify actions it had taken. Blew me away!



# Future Changes to workflow:
1. Actual tests! I had no tests in my application.
2. I want to use some of the approaches I'm reading about with this new style of coding. For example, Steve Yegge or Simon Willison... Using Claude skills, Beads, etc.