lfs = require "lfs"

expose "fake LOVE 0.10.1", ->

    _G.love = require "spec/love"

describe "Pop.Box", ->

    --it "errors when require'd wrong", ->
    --    assert.error -> require "init"

    it "can be required by 'init'", ->
        assert.has_no.errors -> require "init"

    pending "errors if you use LOVE < 0.9.1", ->

    describe "pop.load", ->

        pending "loads all elements", ->
            -- check they are in elements[name]
            -- check specifics if able have used their load functions
            -- if able, check that custom wraps have been called

        pending "loads all skins", ->
            -- see checks for loading all elements

        pending "loads all extensions", ->
            -- see checks for loading all elements

        pending "creates an element the size of the game window", ->
            -- use our shim's width/height, check the size of the element, check that it actually is an element class object, make sure it is stored in pop.screen

    pending "check inherit checker", ->

    describe "pop.create", ->
        -- these need to check parent/child relations and data relations
        pending "creates elements with pop.screen by default", ->
        pending "creates elements with no parent when you pass false", ->
        pending "creates elements with specified parent when passed an element", ->

    describe "pop.update", ->
        pending "only updates when data.update is truthy", ->
        pending "updates all children", ->

    describe "pop.draw", ->
        pending "draws elements only when data.draw is truthy", ->
        pending "draws all children", ->

    describe "pop.mousemoved", ->
        pending "handles mousemoved events on a focused element", ->
            --idk exactly how to make a unit test for this...

    describe "pop.mousepressed", ->
        pending "idk", ->

    describe "pop.mousereleased", ->

        describe "click handling", ->

        describe "mouserelease handling", ->

    describe "pop.keypressed", ->
        pending "idk", ->

    describe "pop.keyreleased", ->
        pending "idk", ->

    describe "pop.textinput", ->
        pending "idk", ->

    describe "pop.debugDraw", ->
        pending "idk", ->

    describe "pop.printElementTree", ->
        pending "idk", ->
