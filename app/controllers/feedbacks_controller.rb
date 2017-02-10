class FeedbacksController < ApplicationController

  def index
    pages_initialization
    @new_feedbacks = Feedback.where(feedback_status: 0)
    @seen_feedbacks = Feedback.where(feedback_status: 1)
    @replied_feedbacks = Feedback.where(feedback_status: 2)

    render 'app/feedback_module'
  end

  def destroy
    feedback_id = params[:id]
    respond_to do |format|
      if Feedback.find(feedback_id).destroy
        format.json { render json: 'Feedback removed!', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

  def update_status
    feedback_id = params[:id]
    status_id = params[:status_id]
    respond_to do |format|
      if Feedback.find(feedback_id).update(feedback_status: status_id)
        format.json { render json: 'Feedback status updated!', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

end
