defmodule Noizu.Assert.ExpectedValue.Constraint do
  require Noizu.Assert.Records
  
  defstruct [
    rhs: nil,
    rhs_name: nil,
    lhs: nil,
    lhs_name: nil,
    message: nil,
    filters: [],
    checks: [],
    __outcome__: nil,
    last_outcome: :ok,
  ]

  @type t :: %Noizu.Assert.ExpectedValue.Constraint{
               rhs: any,
               rhs_name: String.t | nil,
               lhs: any,
               lhs_name: String.t | nil,
               message: String.t | nil,
               filters: [Noizu.Assert.Records.directive],
               checks: [any],
               __outcome__: any, # %{key => Map | List  => .. [check outcomes]}
               last_outcome: :ok
             }
end