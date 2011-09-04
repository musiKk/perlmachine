---
layout: post
title: JVMS Madness
---

This is something I'm carrying around with me for quite some time.

The [Java Virtual Machine Specification][JVMS] (JVMS) is some heavy document. In my opinion it suffers from many problems, some of which I want to discuss in this post.

 [JVMS]: http://java.sun.com/docs/books/jvms/second_edition/html/VMSpecTOC.doc.html

# It is Unstructured

This is the killer for any specification. There is much important information buried in prose and scattered around the document. I have the biggest pains with class loading. [§2.17][JVMS2.17] describes main concepts for the execution of a Java program. It hints at things to come: verification, preparation and resolution. Lots of prose follows. The thing is: this information is very specific and critical for implementation of a JVM. It doesn't belong in a chapter that discusses Java programming language concepts.

In chapter 5 much of this information is structurally duplicated but different. [§5.4][JVMS5.4] discusses verification, preparation and resolution again constantly linking to the different sections of [§2.17][JVMS2.17]. This information belongs together, why are there two chapters in between? I don't know. Instead they are separate and different contexts are munched together that are present at one location but not the other. §5.4 suddenly introduces access control. So this makes it part of the execution but not the concept.

In my opinion there should be one procedure somewhere that covers everything from the name of a class to a usable representation inside the JVM. It may be text, it may be a diagram but currently this information is just scattered around everwhere. Sooner or later I may create such a diagram just to be able to wrap my head around that. But currently it's just difficult.

 [JVMS2.17]: http://java.sun.com/docs/books/jvms/second_edition/html/Concepts.doc.html#16491
 [JVMS5.4]: http://java.sun.com/docs/books/jvms/second_edition/html/ConstantPool.doc.html#71418

# It Does a Poor Job of Introducing new Lingo

There are many terms that are used without good introduction and/or without any explanation of implications or importance. Examples are:

## Runtime Package

This term is used three times in chapter 5. It is explained what it is but the implications are foggy. By my understanding a runtime package is the package of a class in relation to its defining class loader. It regulates visibility of classes and members just like Java packages do but with one important difference: Two instances of the same class loaded by two different class loaders cannot access each other's package private members. Nowadays this is very important (OSGi) so the whole term is underutilized.

## Defining vs. Initializing Class Loader

Why is it important to differentiate between the two?

## Loading, Deriving, Creating, Defining, …

There are many terms used for similar things. All somehow describe the transformation of a binary stream, commonly a class file on the hard drive, to a parsed structure the JVM knows how to handle. A class loader creates a class by loading and maybe defining it. Or something like that.

## Bootstrap Class Loader

What exactly is it? I mean I know what bootstrapping is but what is the bootstrapping class loader? Is it some internal loading mechanism that has nothing to do with Java? I strongly think so because [`Class#getClassLoader()`][Class#getClassLoader] writes that *Some implementations may use null to represent the bootstrap class loader.* This would mean that there is no way to access the bootstrap class loader directly from Java. Probably because it is written in the host language and provides no interface to the Java world.

 [Class#getClassLoader]: http://download.oracle.com/javase/6/docs/api/java/lang/Class.html#getClassLoader()

# Boundaries Between Java and JVM Sometimes Unclear

When does a JVM create Java compatible structures of things? Do I need to create an instance of `java.lang.Class` for every class that's ever loaded or may I live with an internal version and create the instance on the fly when someone requests it? Same for class loaders.

# There is no Single Document

The latest standalone version of the JVMS is the [second edition][JVMS]. But this specification is on par with Java 1.4. There are for instance no annotations or class literals. To find information about those you have to search around. Fortunately the list of [clarifications and amendments][CaA] lists all changes for Java 1.5 but this information is scattered around four different PDFs with one chapter each. Then there are three named JSRs that have to be taken into account and maybe even more. Who knows. Where are the changes for Java 1.6? I'm sure there are some…

§5.3.4 refers to a paper named *Dynamic Class Loading in the Java Virtual Machine*. It is not clear whether this is just supplementary information that clarifies what's already been said or whether this information is critical. I think it's the former. Certainly it's some interesting information.

 [JVMS]: http://java.sun.com/docs/books/jvms/second_edition/html/VMSpecTOC.doc.html
 [CaA]: http://java.sun.com/docs/books/vmspec/2nd-edition/jvms-clarify.html

# Lack of Diagrams

This may be a bit controversial. There are a lot of state changes happening during different procedures. It's hard to follow the flow when all you get is a small listing with a lot of links to other sections. Thanks to that marvelous invention of Hypertext this is fast but I'm still jumping back and forth to understand simple procedures.

I think well written text can live without pictures but you know the saying: A picture is worth a thousand words.

# Final Thoughts

It is not all bad. The JVMS is a very complex specification and it takes a lot of time to read through it and follow it all. I can't say I do. But still there are some serious shortcomings that hinder access to it's content quite a lot. The overall structure is the biggest problem in my opinion. Nothing that can't be overcome with time but unnecessary nonetheless.

Rant off.
