require 'rails_helper'

RSpec.describe Job, type: :model do
  before do
    @user = User.first
    @namespace = @user.namespace

    allow_any_instance_of(Rabbit).to receive(:enqueue)
  end

  context ".create" do
    it "should create a new job" do
      job = Job.new(user: @user, namespace: @namespace)
      expect(job).to receive(:enqueue!)
      job.save
      expect(job).to be_persisted
    end
  end

  describe "update attributes pipeline" do
    let!(:job) { Job.create(user: @user, namespace: @namespace) }

    context "#start!" do
      it "should update attributes" do
        job.start!

        expect(job.started_at).to be_a(DateTime)
        expect(job.status).to eq('running')
      end
    end

    context "#success!" do
      before do
        job.start!
      end

      it "should update attributes" do
        job.success!

        expect(job.finished_at).to be_a(DateTime)
        expect(job.status).to eq('done')
        expect(job.success).to eq(true)
        expect(job.duration).to be_a(Float)
      end
    end

    context "#retry!" do
      before do
        job.start!
      end

      it "should update attributes" do
        job.retry!("Error message")

        expect(job.finished_at).to be_nil
        expect(job.status).to eq('retry')
        expect(job.success).to be_nil
        expect(job.duration).to be_a(Float)
        expect(job.messages).to eq(["Error message"])
      end
    end

    context "#fail" do
      before do
        job.start!
      end

      it "should update attributes" do
        job.fail!("Error message")

        expect(job.finished_at).to be_a(DateTime)
        expect(job.status).to eq('done')
        expect(job.success).to eq(false)
        expect(job.duration).to be_a(Float)
        expect(job.messages).to eq(["Error message"])
      end
    end

    context "#complete?" do
      before { job.start! }

      it "should complete job when success!" do
        expect(job).not_to be_complete

        job.success!

        expect(job).to be_complete
      end

      it "should complete job when fail!" do
        expect(job).not_to be_complete

        job.fail!("error")

        expect(job).to be_complete
      end
    end
  end
end
