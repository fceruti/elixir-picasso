defmodule Picasso.Datastore.Behaviour do
  @doc """
  Copies the file named `filename` from the datastore to /tmp/ and turns it's path.
  """
  @callback read(filename :: String.t()) :: {:error, atom} | {:ok, String.t()}

  @doc """
  Stores the file at `tmp_path` as `filename` at the datastore.
  """
  @callback store(tmp_path :: String.t(), filename :: String.t()) ::
              {:error, atom} | {:ok, String.t()}

  @doc """
  Removes the file named `filename` from the datastore.
  """
  @callback remove(filename :: String.t()) :: {:error, atom} | {:ok, String.t()}
end
