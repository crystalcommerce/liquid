require 'test_helper'

class FileSystemTest < Test::Unit::TestCase
  include Liquid

  def test_default
    assert_raise(FileSystemError) do
      BlankFileSystem.new.read_template_file({'dummy'=>'smarty'}, "dummy")
    end
  end

  def test_local
    local_dir = "#{File.dirname(File.expand_path(__FILE__))}/file_system_test"
    file_system = Liquid::LocalFileSystem.new(local_dir)
    assert_equal "#{local_dir}/_mypartial.liquid"    , file_system.full_path("mypartial")
    assert_equal "#{local_dir}/dir/_mypartial.liquid", file_system.full_path("dir/mypartial")

    assert_raise(FileSystemError) do
      file_system.full_path("../dir/mypartial")
    end

    assert_raise(FileSystemError) do
      file_system.full_path("/dir/../../dir/mypartial")
    end

    assert_raise(FileSystemError) do
      file_system.full_path("/etc/passwd")
    end
  end

  def test_multiple_roots
    local_dir = "#{File.dirname(File.expand_path(__FILE__))}/file_system_test"
    file_system = Liquid::LocalFileSystem.new(local_dir, "#{local_dir}/dir")
    assert_equal "#{local_dir}/_mypartial.liquid", file_system.full_path("mypartial")
    assert_equal "#{local_dir}/dir/_onepartial.liquid", file_system.full_path("onepartial")
  end
end # FileSystemTest
