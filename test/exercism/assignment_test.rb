require './test/test_helper'

class AssignmentTest < MiniTest::Unit::TestCase

  def project_dir
    '/tmp'
  end

  def teardown
    FileUtils.rm_rf File.join(project_dir, 'ruby')
  end

  def readme_path
    File.join(project_dir, 'ruby', 'queens', 'README.md')
  end

  def tests_dir
    File.join(project_dir, 'ruby', 'queens')
  end

  def tests_path
    File.join(tests_dir, 'test.rb')
  end

  def assignment_data
    {
      'track' => 'ruby',
      'slug' => 'queens',
      'readme' => 'Do it',
      'test_file' => 'test.rb',
      'tests' => 'assert true',
      'project_dir' => project_dir
    }
  end

  def test_write_assignment_from_project_directory
    assignment = Exercism::Assignment.new(assignment_data)
    assignment.save

    assert_equal "Do it", File.read(readme_path)
    assert_equal "assert true", File.read(tests_path)
  end

  def test_do_not_overwrite_existing_test_file
    FileUtils.mkdir_p(tests_dir)
    FileUtils.touch(tests_path)
    File.open(tests_path, 'w') do |file|
      file.write 'assert false'
    end

    Exercism::Assignment.new(assignment_data).save

    assert_equal "assert false", File.read(tests_path)
  end
end

