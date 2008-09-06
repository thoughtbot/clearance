require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ContextTest < Test::Unit::TestCase # :nodoc:
  
  def self.context_macro(&blk)
    context "with a subcontext made by a macro" do
      setup { @context_macro = :foo }

      merge_block &blk 
    end
  end

  # def self.context_macro(&blk)
  #   context "with a subcontext made by a macro" do
  #     setup { @context_macro = :foo }
  #     yield # <- this doesn't work.
  #   end
  # end

  context "context with setup block" do
    setup do
      @blah = "blah"
    end
    
    should "run the setup block" do
      assert_equal "blah", @blah
    end
    
    should "have name set right" do
      assert_match(/^test: context with setup block/, self.to_s)
    end

    context "and a subcontext" do
      setup do
        @blah = "#{@blah} twice"
      end
      
      should "be named correctly" do
        assert_match(/^test: context with setup block and a subcontext should be named correctly/, self.to_s)
      end
      
      should "run the setup blocks in order" do
        assert_equal @blah, "blah twice"
      end
    end

    context_macro do
      should "have name set right" do
        assert_match(/^test: context with setup block with a subcontext made by a macro should have name set right/, self.to_s)
      end

      should "run the setup block of that context macro" do
        assert_equal :foo, @context_macro
      end

      should "run the setup block of the main context" do
        assert_equal "blah", @blah
      end
    end

  end

  context "another context with setup block" do
    setup do
      @blah = "foo"
    end
    
    should "have @blah == 'foo'" do
      assert_equal "foo", @blah
    end

    should "have name set right" do
      assert_match(/^test: another context with setup block/, self.to_s)
    end
  end
  
  context "context with method definition" do
    setup do
      def hello; "hi"; end
    end
    
    should "be able to read that method" do
      assert_equal "hi", hello
    end

    should "have name set right" do
      assert_match(/^test: context with method definition/, self.to_s)
    end
  end
  
  context "another context" do
    should "not define @blah" do
      assert_nil @blah
    end
  end
    
  context "context with multiple setups and/or teardowns" do
    
    cleanup_count = 0
        
    2.times do |i|
      setup { cleanup_count += 1 }
      teardown { cleanup_count -= 1 }
    end
    
    2.times do |i|
      should "call all setups and all teardowns (check ##{i + 1})" do
        assert_equal 2, cleanup_count
      end
    end
    
    context "subcontexts" do
      
      2.times do |i|
        setup { cleanup_count += 1 }
        teardown { cleanup_count -= 1 }
      end
                  
      2.times do |i|
        should "also call all setups and all teardowns in parent and subcontext (check ##{i + 1})" do
          assert_equal 4, cleanup_count
        end
      end
      
    end
    
  end
  
  should_eventually "pass, since it's unimplemented" do
    flunk "what?"
  end

  should_eventually "not require a block when using should_eventually"
  should "pass without a block, as that causes it to piggyback to should_eventually"
  
  context "context for testing should piggybacking" do
    should "call should_eventually as we are not passing a block"
  end

  context "context" do
    context "with nested subcontexts" do
      should_eventually "only print this statement once for a should_eventually"
    end
  end
end
